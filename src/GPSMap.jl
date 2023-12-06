module GPSMap

using DelaunayTriangulation: get_edges, triangulate

using LazySets: VPolygon, Singleton, element

using MultivariateStats: MetricMDS, fit

using ..Nucleus

function _log_coordinate(an_, co___)

    n_pa = maximum(lastindex, an_) + 4

    @info "$(lastindex(an_)) coordinates\n" * join(
        (
            "$(rpad(an, n_pa))$(Nucleus.Number.format2(co1))\t$(Nucleus.Number.format2(co2))" for
            (an, (co1, co2)) in zip(an_, co___)
        ),
        '\n',
    )

end

function _get_coordinate!(no_x_no_x_di, no_x_po_x_pu)

    di_x_no_x_co = fit(MetricMDS, no_x_no_x_di; distances = true, maxoutdim = 2, maxiter = 10^3).X

    foreach(Nucleus.Normalization.normalize_with_sum!, eachcol(no_x_po_x_pu))

    di_x_no_x_co, di_x_no_x_co * no_x_po_x_pu

end

function plot(
    ht,
    no_,
    po_,
    no_x_po_x_pu,
    no_x_no_x_di;
    node_marker_size = 48,
    node_marker_color = "#23191e",
    node_marker_line_width = 2,
    node_marker_line_color = Nucleus.Color.HEFA,
    triangulation_line_color = "#171412",
    point_marker_size = 16,
    point_marker_line_width = 0.8,
    point_marker_line_color = "#898a74",
    point_marker_opacity = 0.88,
    la_ = (),
    sc_ = (),
)

    n_no = lastindex(no_)

    n_po = lastindex(po_)

    di_x_no_x_co, di_x_po_x_co = _get_coordinate!(no_x_no_x_di, no_x_po_x_pu)

    data = Dict{String, Any}[]

    tr = triangulate(eachcol(di_x_no_x_co))

    for id_ in get_edges(tr)

        if any(==(-1), id_)

            continue

        end

        ve = collect(id_)

        push!(
            data,
            Dict(
                "legendgroup" => "Node",
                "showlegend" => false,
                "y" => view(di_x_no_x_co, 1, ve),
                "x" => view(di_x_no_x_co, 2, ve),
                "mode" => "lines",
                "line" => Dict("color" => triangulation_line_color),
            ),
        )

    end

    pl = VPolygon(di_x_no_x_co[:, tr.convex_hull.indices])

    push!(
        data,
        Dict(
            "legendgroupname" => "XX",
            "legendgroup" => "Node",
            "name" => "Node",
            "y" => view(di_x_no_x_co, 1, :),
            "x" => view(di_x_no_x_co, 2, :),
            "text" => no_,
            "mode" => "markers",
            "marker" => Dict(
                "size" => node_marker_size,
                "color" => node_marker_color,
                "line" =>
                    Dict("width" => node_marker_line_width, "color" => node_marker_line_color),
            ),
            "hoverinfo" => "text",
        ),
    )

    annotations = Dict{String, Any}[]

    for (no, (co1, co2)) in zip(no_, eachcol(di_x_no_x_co))

        push!(
            annotations,
            Dict(
                "y" => co1,
                "x" => co2,
                "text" => "<b>$no</b>",
                "font" => Dict(
                    "family" => "Gravitas One, monospace",
                    "size" => 16,
                    "color" => node_marker_color,
                ),
                "bgcolor" => "#ffffff",
                "borderpad" => 2,
                "borderwidth" => node_marker_line_width,
                "bordercolor" => node_marker_line_color,
                "arrowwidth" => node_marker_line_width,
                "arrowcolor" => node_marker_line_color,
            ),
        )

    end

    n_po = 64

    npoints = (n_po, n_po)

    ro_, co_, de = Nucleus.Density.estimate((di_x_po_x_co[1, :], di_x_po_x_co[2, :]); npoints)

    ou = [!(element(Singleton([ro, co])) ∈ pl) for ro in ro_, co in co_]

    de[ou] .= NaN

    push!(
        data,
        Dict(
            "type" => "contour",
            "legendgroup" => "Point",
            "showlegend" => false,
            "y" => ro_,
            "x" => co_,
            "z" => de,
            "transpose" => true,
            "ncontours" => 32,
            "contours" => Dict("coloring" => "none"),
        ),
    )

    point = Dict(
        "legendgroup" => "Point",
        "name" => "Point",
        "mode" => "markers",
        "marker" => Dict(
            "size" => point_marker_size,
            "color" => Nucleus.Color.HEGE,
            "line" => Dict("width" => point_marker_line_width, "color" => point_marker_line_color),
            "opacity" => point_marker_opacity,
        ),
        "hoverinfo" => "text",
    )

    if isempty(sc_)

        push!(
            data,
            merge(
                point,
                Dict(
                    "y" => view(di_x_po_x_co, 1, :),
                    "x" => view(di_x_po_x_co, 2, :),
                    "text" => po_,
                ),
            ),
        )

    elseif eltype(sc_) <: Integer

        un_ = sort!(unique(sc_))

        n_un = lastindex(un_)

        cu = Array{Float64, 3}(undef, n_po, n_po, n_un)

        for (id, un) in enumerate(un_)

            id_ = findall(==(un), sc_)

            _ro_, _co_, de = Nucleus.Density.estimate(
                (di_x_po_x_co[1, id_], di_x_po_x_co[2, id_]);
                boundary,
                npoints,
            )
            @assert ro_ == _ro_
            @assert co_ == _co_

            pr = de / sum(de)

            pr[ou] .= NaN

            cu[:, :, id] = pr

        end

        id_ = 1:n_po

        # TODO: Benchmark iteration order.
        for id2 in id_, id1 in id_

            # TODO: Benchmark `view`.
            pr_ = view(cu, id1, id2, :)

            if all(isnan, pr_)

                continue

            end
            @assert !any(isnan, pr_)

            ma = argmax(pr_)

            for id in 1:n_un

                if id != ma

                    pr_[id] = NaN

                end

            end

        end

        for (id, (un, color)) in enumerate(zip(un_, Nucleus.Color.color(un_)))

            push!(
                data,
                Dict(
                    "type" => "heatmap",
                    "legendgroup" => un,
                    "y" => ro_,
                    "x" => co_,
                    "z" => cu[:, :, id],
                    "transpose" => true,
                    "colorscale" => Nucleus.Color.fractionate(
                        Nucleus.Color._make_color_scheme(["#ffffff", color]),
                    ),
                    #"opacity" => 1,
                    "showscale" => false,
                    "hoverinfo" => "none",
                ),
            )

            id_ = findall(==(un), sc_)

            push!(
                data,
                Nucleus.Dict.merge(
                    point,
                    Dict(
                        "legendgroup" => un,
                        "name" => un,
                        "y" => view(di_x_po_x_co, 1, id_),
                        "x" => view(di_x_po_x_co, 2, id_),
                        "text" => po_[id_],
                        "marker" => Dict("color" => color),
                    ),
                ),
            )

        end

    elseif eltype(sc_) <: AbstractVector

    end

    axis = Dict("showgrid" => false, "zeroline" => false, "showticklabels" => true)

    layout = Dict(
        "height" => 800,
        "width" => 960,
        "title" => Dict("text" => "GPS Map<br>$n_no nodes and $n_po points"),
        "yaxis" => merge(axis, Dict("autorange" => "reversed")),
        "xaxis" => axis,
        "annotations" => annotations,
    )

    Nucleus.Plot.plot(ht, data, layout)

end

end
