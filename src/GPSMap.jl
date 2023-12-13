module GPSMap

using DelaunayTriangulation: get_edges

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
    node_annotation_borderwidth = node_marker_line_width,
    node_annotation_bordercolor = node_marker_line_color,
    node_annotation_arrowwidth = node_marker_line_width,
    node_annotation_arrowcolor = node_marker_line_color,
    n_gr = 128,
    point_marker_size = 16,
    point_marker_opacity = 0.88,
    point_marker_line_width = 0.8,
    sc_ = (),
)

    data = Dict{String, Any}[]

    di_x_no_x_co = Nucleus.Coordinate.get(no_x_no_x_di)

    tr = Nucleus.Coordinate.triangulate(eachcol(di_x_no_x_co))

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
                "hoverinfo" => "none",
            ),
        )

    end

    push!(
        data,
        Dict(
            "legendgroup" => "Node",
            "name" => "Node",
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

    annotations = [
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
            "borderwidth" => node_annotation_borderwidth,
            "bordercolor" => node_annotation_bordercolor,
            "arrowwidth" => node_annotation_arrowwidth,
            "arrowcolor" => node_annotation_arrowcolor,
        ) for (no, (co1, co2)) in zip(no_, eachcol(di_x_no_x_co))
    ]

    boundary = (
        Nucleus.Collection.get_minimum_maximum(di_x_no_x_co[1, :]),
        Nucleus.Collection.get_minimum_maximum(di_x_no_x_co[2, :]),
    )

    npoints = (n_gr, n_gr)

    di_x_po_x_co = Nucleus.Coordinate.pull(di_x_no_x_co, no_x_po_x_pu)

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

    vp = Nucleus.Coordinate.wall(tr)

    is = [!Nucleus.Coordinate.is_in([ro, co], vp) for ro in ro_, co in co_]

    de[is] .= NaN

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
            "hoverinfo" => "none",
        ),
    )

    point = Dict(
        "mode" => "markers",
        "marker" => Dict(
            "size" => point_marker_size,
            "opacity" => point_marker_opacity,
            "line" => Dict("width" => point_marker_line_width),
        ),
    )

    if isempty(sc_)

        push!(
            data,
            Nucleus.Dict.merge(
                point,
                Dict(
                    "legendgroup" => "Point",
                    "name" => "Point",
                    "y" => view(di_x_po_x_co, 1, :),
                    "x" => view(di_x_po_x_co, 2, :),
                    "text" => po_,
                    "marker" => Dict("color" => Nucleus.Color.HEGE),
                    "hoverinfo" => "text",
                ),
            ),
        )

    elseif eltype(sc_) <: Integer

        un_ = sort!(unique(sc_))

        n_un = lastindex(un_)

        gr_x_gr_x_un_x_pr = Array{Float64, 3}(undef, n_gr, n_gr, n_un)

        for (id, un) in enumerate(un_)

            id_ = findall(==(un), sc_)

            _ro_, _co_, de = Nucleus.Density.estimate(
                (di_x_po_x_co[1, id_], di_x_po_x_co[2, id_]);
                boundary,
                npoints,
                bandwidth,
            )

            de[is] .= NaN

            gr_x_gr_x_un_x_pr[:, :, id] = de

        end

        # TODO: Benchmark iteration order.
        for id2 in 1:n_gr, id1 in 1:n_gr

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

            # TODO: Do this once.
            id_ = findall(==(un), sc_)

            push!(
                data,
                Dict(
                    "type" => "heatmap",
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
