module GPSMap

using DelaunayTriangulation: get_convex_hull_indices, get_edges, triangulate

using LazySets: VPolygon, Singleton, element

using ..Nucleus

function plot(
    ht,
    no_,
    no_x_no_x_di,
    po_,
    no_x_po_x_pu;
    triangulation_line_color = "#171412",
    node_marker_size = 48,
    node_marker_opacity = 1,
    node_marker_color = "#23191e",
    node_marker_line_width = 2,
    node_marker_line_color = Nucleus.Color.HEFA,
    n_gr = 128,
    la_ = (),
    point_marker_size = 16,
    point_marker_opacity = 0.88,
    point_marker_line_width = 0.8,
    sc_ = (),
)

    data = Dict{String, Any}[]

    annotations = Dict{String, Any}[]

    di_x_no_x_co = Nucleus.Coordinate.get(no_x_no_x_di)

    tr = triangulate(eachcol(di_x_no_x_co))

    vp = VPolygon(di_x_no_x_co[:, tr.convex_hull.indices])

    for id_ in get_edges(tr)

        if any(==(-1), id_)

            continue

        end

        ve = collect(id_)

        push!(
            data,
            Dict(
                "y" => view(di_x_no_x_co, 1, ve),
                "x" => view(di_x_no_x_co, 2, ve),
                "mode" => "lines",
                "line" => Dict("color" => triangulation_line_color),
                "hoverinfo" => "none",
            ),
        )

    end

    push!(
        data,
        Dict(
            "y" => view(di_x_no_x_co, 1, :),
            "x" => view(di_x_no_x_co, 2, :),
            "text" => no_,
            "mode" => "markers",
            "marker" => Dict(
                "size" => node_marker_size,
                "opacity" => node_marker_opacity,
                "color" => node_marker_color,
                "line" =>
                    Dict("width" => node_marker_line_width, "color" => node_marker_line_color),
            ),
            "hoverinfo" => "text",
        ),
    )

    append!(
        annotations,
        [
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
            ) for (no, (co1, co2)) in zip(no_, eachcol(di_x_no_x_co))
        ],
    )

    di_x_po_x_co = Nucleus.Coordinate.pull(di_x_no_x_co, no_x_po_x_pu)

    boundary = (
        Nucleus.Collection.get_minimum_maximum(di_x_po_x_co[1, :]),
        Nucleus.Collection.get_minimum_maximum(di_x_po_x_co[2, :]),
    )

    npoints = (n_gr, n_gr)

    bandwidth = (
        Nucleus.Density.get_bandwidth(di_x_po_x_co[1, :]),
        Nucleus.Density.get_bandwidth(di_x_po_x_co[2, :]),
    )

    ro_, co_, de = Nucleus.Density.estimate(
        (di_x_po_x_co[1, :], di_x_po_x_co[2, :]);
        boundary,
        npoints,
        bandwidth,
    )

    ou = [!(element(Singleton([ro, co])) ∈ vp) for ro in ro_, co in co_]

    de[ou] .= NaN

    push!(
        data,
        Dict(
            "type" => "contour",
            "y" => ro_,
            "x" => co_,
            "z" => de,
            "transpose" => true,
            "ncontours" => 32,
            "contours" => Dict("coloring" => "none"),
            "hoverinfo" => "none",
        ),
    )

    if !isempty(la_)

        un_ = sort!(unique(la_))

        n_un = lastindex(un_)

        gr_x_gr_x_un_x_pr = Array{Float64, 3}(undef, n_gr, n_gr, n_un)

        for (id, un) in enumerate(un_)

            id_ = findall(==(un), la_)

            _ro_, _co_, de = Nucleus.Density.estimate(
                (di_x_po_x_co[1, id_], di_x_po_x_co[2, id_]);
                boundary,
                npoints,
                bandwidth,
            )

            de[ou] .= NaN

            gr_x_gr_x_un_x_pr[:, :, id] = de

        end

        id_ = 1:n_gr

        # TODO: Benchmark iteration order.
        for id2 in id_, id1 in id_

            pr_ = view(gr_x_gr_x_un_x_pr, id1, id2, :)

            if all(isnan, pr_)

                continue

            end

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
                    "z" => view(gr_x_gr_x_un_x_pr, :, :, id),
                    "transpose" => true,
                    "colorscale" => Nucleus.Color.fractionate(
                        Nucleus.Color._make_color_scheme(["#ffffff", color]),
                    ),
                    "showscale" => false,
                    "hoverinfo" => "none",
                ),
            )

        end

    end

    if isempty(sc_)

        push!(
            data,
            Dict(
                "y" => view(di_x_po_x_co, 1, :),
                "x" => view(di_x_po_x_co, 2, :),
                "text" => po_,
                "mode" => "markers",
                "marker" => Dict(
                    "size" => point_marker_size,
                    "opacity" => point_marker_opacity,
                    "color" => Nucleus.Color.HEGE,
                    "line" => Dict("width" => point_marker_line_width, "color" => "#898a74"),
                ),
                "hoverinfo" => "text",
            ),
        )

    elseif eltype(sc_) <: Integer

        un_ = sort!(unique(sc_))

        for (un, color) in zip(un_, Nucleus.Color.color(un_))

            id_ = findall(==(un), sc_)

            push!(
                data,
                Dict(
                    "y" => view(di_x_po_x_co, 1, id_),
                    "x" => view(di_x_po_x_co, 2, id_),
                    "text" => view(di_x_po_x_co, :, id_),
                    "mode" => "markers",
                    "marker" => Dict(
                        "size" => point_marker_size,
                        "opacity" => point_marker_opacity,
                        "color" => color,
                        "line" => Dict("width" => point_marker_line_width),
                    ),
                    "hoverinfo" => "text",
                ),
            )

        end

    elseif eltype(sc_) <: AbstractVector

        error()

    end

    axis = Dict("showgrid" => false, "zeroline" => false, "ticks" => "", "showticklabels" => false)

    Nucleus.Plot.plot(
        ht,
        data,
        Dict(
            "height" => 800,
            "width" => 960,
            "title" =>
                Dict("text" => "GPS Map<br>$(lastindex(no_)) nodes and $(lastindex(po_)) points"),
            "yaxis" => merge(axis, Dict("autorange" => "reversed")),
            "xaxis" => axis,
            "annotations" => annotations,
        ),
    )

end

end
