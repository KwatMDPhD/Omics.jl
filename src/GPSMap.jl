module GPSMap

using DelaunayTriangulation: get_convex_hull_indices, get_edges, get_points, triangulate

using LazySets: VPolygon, Singleton, element

using ..Nucleus

function _trace!(data, tr, color)

    co___ = get_points(tr)

    for id_ in get_edges(tr)

        if any(==(-1), id_)

            continue

        end

        push!(
            data,
            Dict(
                "y" => [co___[id][1] for id in id_],
                "x" => [co___[id][2] for id in id_],
                "mode" => "lines",
                "line" => Dict("color" => color),
                "hoverinfo" => "none",
            ),
        )

    end

end

function _make_probability_and_mask!(de, ou)

    de ./= sum(de)

    de[ou] .= NaN

end

function _trace!(data, ro_, co_, de)

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
            #"showscale"=>false,
            "hoverinfo" => "none",
        ),
    )

end

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

    _trace!(data, tr, triangulation_line_color)

    Nucleus.Coordinate.trace!(
        data,
        no_,
        di_x_no_x_co,
        node_marker_size,
        node_marker_opacity,
        node_marker_color,
        node_marker_line_width,
        node_marker_line_color,
    )

    Nucleus.Coordinate.annotate!(
        annotations,
        no_,
        di_x_no_x_co,
        node_marker_color,
        node_marker_line_width,
        node_marker_line_color,
    )

    di_x_po_x_co = Nucleus.Coordinate.pull(di_x_no_x_co, no_x_po_x_pu)

    fa = 1.1

    boundary = (
        Nucleus.Collection.get_minimum_maximum(di_x_po_x_co[1, :]) .* fa,
        Nucleus.Collection.get_minimum_maximum(di_x_po_x_co[2, :]) .* fa,
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

    #ou = [!(element(Singleton([ro, co])) ∈ vp) for ro in ro_, co in co_]

    #_make_probability_and_mask!(de, ou)

    _trace!(data, ro_, co_, de)

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

            #make_probability_and_mask!(de, ou)

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

        Nucleus.Coordinate.trace!(
            data,
            po_,
            di_x_po_x_co,
            point_marker_size,
            point_marker_opacity,
            Nucleus.Color.HEGE,
            point_marker_line_width,
            "#898a74",
        )

    elseif eltype(sc_) <: Integer

        un_ = sort!(unique(sc_))

        for (un, color) in zip(un_, Nucleus.Color.color(un_))

            id_ = findall(==(un), sc_)

            Nucleus.Coordinate.trace!(
                data,
                view(po_, id_),
                view(di_x_po_x_co, :, id_),
                point_marker_size,
                point_marker_opacity,
                color,
                point_marker_line_width,
                "#898a74",
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
