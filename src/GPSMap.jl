module GPSMap

using DelaunayTriangulation: get_edges, triangulate

using LazySets: VPolygon, Singleton, element

using MultivariateStats: MetricMDS, fit

using ..Nucleus

function _get_coordinate(no_x_no_x_di)

    fit(MetricMDS, no_x_no_x_di; distances = true, maxoutdim = 2, maxiter = 10^3).X

end

function _get_coordinate(di_x_no_x_co, no_x_po_x_pu)

    no_x_po_x_pu = copy(no_x_po_x_pu)

    foreach(Nucleus.Normalization.normalize_with_sum!, eachcol(no_x_po_x_pu))

    di_x_no_x_co * no_x_po_x_pu

end

function make_probability_and_mask!(de, ou)

    de ./= sum(de)

    de[ou] .= NaN

end

function plot(
    ht,
    no_,
    no_x_no_x_di,
    po_,
    no_x_po_x_pu;
    triangulation_line_color = "#171412",
    node_marker_size = 48,
    node_marker_color = "#23191e",
    node_marker_line_width = 2,
    node_marker_line_color = Nucleus.Color.HEFA,
    n_gr = 128,
    la_ = (),
    point_marker_size = 16,
    point_marker_line_width = 0.8,
    point_marker_opacity = 0.88,
    sc_ = (),
)

    data = Dict{String, Any}[]

    legendgroup = "Node"

    di_x_no_x_co = _get_coordinate(no_x_no_x_di)

    tr = triangulate(eachcol(di_x_no_x_co))

    for id_ in get_edges(tr)

        if any(==(-1), id_)

            continue

        end

        ve = collect(id_)

        push!(
            data,
            Dict(
                "legendgroup" => legendgroup,
                "showlegend" => false,
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
            "legendgroup" => legendgroup,
            "name" => legendgroup,
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

    legendgroup = "Point"

    di_x_po_x_co = _get_coordinate(di_x_no_x_co, no_x_po_x_pu)

    fa = 1.1

    boundary = (
        Nucleus.Collection.get_minimum_maximum(view(di_x_no_x_co, 1, :) .* fa),
        Nucleus.Collection.get_minimum_maximum(view(di_x_no_x_co, 2, :) .* fa),
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

    pl = VPolygon(di_x_no_x_co[:, tr.convex_hull.indices])

    ou = [!(element(Singleton([ro, co])) ∈ pl) for ro in ro_, co in co_]

    make_probability_and_mask!(de, ou)

    push!(
        data,
        Dict(
            "type" => "contour",
            "legendgroup" => legendgroup,
            "showlegend" => false,
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

            make_probability_and_mask!(de, ou)

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

    point = Dict(
        "legendgroup" => legendgroup,
        "name" => legendgroup,
        "mode" => "markers",
        "marker" => Dict(
            "size" => point_marker_size,
            "line" => Dict("width" => point_marker_line_width, "color" => "#898a74"),
            "opacity" => point_marker_opacity,
        ),
        "hoverinfo" => "text",
    )

    if isempty(sc_)

        push!(
            data,
            Nucleus.Dict.merge(
                point,
                Dict(
                    "y" => view(di_x_po_x_co, 1, :),
                    "x" => view(di_x_po_x_co, 2, :),
                    "text" => po_,
                    "marker" => Dict("color" => Nucleus.Color.HEGE),
                ),
            ),
        )

    elseif eltype(sc_) <: Integer

        un_ = sort!(unique(sc_))

        for (un, color) in zip(un_, Nucleus.Color.color(un_))

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
                        "text" => view(po_, id_),
                        "marker" => Dict("color" => color),
                    ),
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
