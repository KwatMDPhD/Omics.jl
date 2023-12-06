module GPSMap

using DelaunayTriangulation: get_edges, triangulate

using LazySets: VPolygon, Singleton, element

using MultivariateStats: MetricMDS, fit

using ..Nucleus

function plot(
    ht,
    no_,
    po_,
    no_x_po_x_pu,
    sc_ = ();
    node_marker_size = 48,
    node_marker_color = "#23191e",
    node_marker_line_width = 2,
    node_marker_line_color = Nucleus.Color.HEFA,
    triangulation_line_color = "#171412",
    point_marker_size = 16,
    point_marker_line_width = 0.8,
    point_marker_line_color = "#898a74",
    point_marker_opacity = 0.88,
)

    n_no = lastindex(no_)

    n_po = lastindex(po_)

    no_x_no_x_di = Nucleus.Distance.get(Nucleus.Distance.Euclidean(), eachrow(no_x_po_x_pu))

    di_x_no_x_co = fit(MetricMDS, no_x_no_x_di; distances = true, maxoutdim = 2).X

    @info "$n_no nodes\n" * join(
        (
            (no, (co1, co2)) ->
                "$no ($(Nucleus.Number.format2(co1)), $(Nucleus.Number.format2(co2)))"
        ).(no_, eachcol(di_x_no_x_co)),
        '\n',
    )

    di_x_po_x_co =
        [sum(co_ .* pu_) / sum(pu_) for co_ in eachrow(di_x_no_x_co), pu_ in eachcol(no_x_po_x_pu)]

    data = Dict{String, Any}[]

    tr = triangulate(Tuple.(eachcol(di_x_no_x_co)))

    for id_ in get_edges(tr)

        if any(==(-1), id_)

            continue

        end

        id2_ = collect(id_)

        push!(
            data,
            Dict(
                "legendgroup" => "Node",
                "showlegend" => false,
                "y" => di_x_no_x_co[1, id2_],
                "x" => di_x_no_x_co[2, id2_],
                "mode" => "lines",
                "line" => Dict("color" => triangulation_line_color),
            ),
        )

    end

    pl = VPolygon([di_x_no_x_co[:, id] for id in tr.convex_hull.indices])

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

    ro_, co_, de = Nucleus.Density.estimate((di_x_po_x_co[1, :], di_x_po_x_co[2, :]))

    ma = [!(element(Singleton([ro, co])) ∈ pl) for ro in ro_, co in co_]

    de[ma] .= NaN

    #Nucleus.Density.plot("", ro_, co_, de)
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
