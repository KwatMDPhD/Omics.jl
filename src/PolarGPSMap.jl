module PolarGPSMap

using ..Nucleus

function plot(
    ht,
    no_,
    di_x_no_x_co,
    po_,
    di_x_po_x_co;
    node_marker_size = 32,
    node_marker_opacity = 0.96,
    node_marker_color = "#171412",
    node_marker_line_width = 2,
    node_marker_line_color = Nucleus.Color.HEFA,
    node_annotation_font_size = 16,
    node_annotation_font_color = node_marker_color,
    node_annotation_bgcolor = "#ffffff",
    node_annotation_borderpad = 2,
    node_annotation_borderwidth = node_marker_line_width,
    node_annotation_bordercolor = node_marker_line_color,
    node_annotation_arrowwidth = 1.6,
    node_annotation_arrowcolor = node_marker_line_color,
    ug = 128,
    ncontours = 32,
    point_marker_size = 16,
    point_marker_opacity = 0.64,
    point_marker_color = Nucleus.Color.HEGE,
    point_marker_line_width = 0.8,
    point_marker_line_color = "#000000",
    sc_ = nothing,
    size = 800,
)

    margin = size * 0.04

    data = [
        Dict(
            "x" => (0,),
            "y" => (0,),
            "mode" => "markers",
            "marker" => Dict(
                "size" => size - 2 * margin,
                "color" => Nucleus.Color.add_alpha("#000000", 0.04),
                "line" => Dict("width" => 2, "color" => Nucleus.Color.HEIP),
            ),
            "cliponaxis" => false,
            "hoverinfo" => "skip",
        ),
    ]

    push!(
        data,
        Dict(
            "x" => view(di_x_no_x_co, 1, :),
            "y" => view(di_x_no_x_co, 2, :),
            "text" => no_,
            "mode" => "markers+text",
            "marker" => Dict(
                "size" => node_marker_size,
                "color" => node_marker_color,
                "line" =>
                    Dict("width" => node_marker_line_width, "color" => node_marker_line_color),
                "opacity" => node_marker_opacity,
            ),
            "textfont" => Dict(
                "family" => "Gravitas One, monospace",
                "size" => node_annotation_font_size,
                "color" => "#ffffff",
            ),
            "cliponaxis" => false,
        ),
    )

    ke_ar = (
        boundary = ((-1.2, 1.2), (-1.2, 1.2)),
        npoints = (ug, ug),
        bandwidth = (
            Nucleus.Density.get_bandwidth(view(di_x_po_x_co, 1, :)),
            Nucleus.Density.get_bandwidth(view(di_x_po_x_co, 2, :)),
        ),
    )

    xc_, yc_, cc =
        Nucleus.Density.estimate((view(di_x_po_x_co, 1, :), view(di_x_po_x_co, 2, :)); ke_ar...)

    aa = [1 < xc^2 + yc^2 for xc in xc_, yc in yc_]

    cc[aa] .= NaN

    push!(
        data,
        Dict(
            "type" => "contour",
            "x" => xc_,
            "y" => yc_,
            "z" => cc,
            "ncontours" => ncontours,
            "contours" => Dict("coloring" => "none"),
            "hoverinfo" => "skip",
        ),
    )

    point = Dict(
        "x" => view(di_x_po_x_co, 1, :),
        "y" => view(di_x_po_x_co, 2, :),
        "text" => po_,
        "mode" => "markers",
        "marker" => Dict(
            "size" => point_marker_size,
            "color" => point_marker_color,
            "line" => Dict("width" => point_marker_line_width, "color" => point_marker_line_color),
            "opacity" => point_marker_opacity,
        ),
    )

    if isnothing(sc_)

        push!(data, point)

    elseif sc_ isa AbstractVector{<:AbstractFloat}

        push!(
            data,
            Nucleus.Dict.merge(
                point,
                Dict("marker" => Dict("color" => Nucleus.Color.color(sc_, Nucleus.Color.COBW))),
            ),
        )

    elseif sc_ isa AbstractVector{<:Integer}

        un_ = unique(sc_)

        gr_x_gr_x_un_x_pr = Array{Float64, 3}(undef, ug, ug, lastindex(un_))

        for (i3, un) in enumerate(un_)

            i2_ = findall(==(un), sc_)

            _xc_, _yc_, rr = Nucleus.Density.estimate(
                (view(di_x_po_x_co, 1, i2_), view(di_x_po_x_co, 2, i2_));
                ke_ar...,
            )

            rr[aa] .= NaN

            gr_x_gr_x_un_x_pr[:, :, i3] = rr

        end

        for i2 in 1:ug, i1 in 1:ug

            pr_ = view(gr_x_gr_x_un_x_pr, i1, i2, :)

            if all(isnan, pr_)

                continue

            end

            ma = argmax(pr_)

            for i3 in eachindex(pr_)

                if i3 != ma

                    pr_[i3] = NaN

                end

            end

        end

        he_ = Nucleus.Color.color(un_)

        for i3 in 1:lastindex(un_)

            push!(
                data,
                Dict(
                    "type" => "heatmap",
                    "x" => xc_,
                    "y" => yc_,
                    "z" => view(gr_x_gr_x_un_x_pr, :, :, i3),
                    "colorscale" => Nucleus.Color.fractionate(
                        Nucleus.Color._make_color_scheme(["#ffffff", he_[i3]]),
                    ),
                    "showscale" => false,
                    "hoverinfo" => "skip",
                ),
            )

            i2_ = findall(==(un_[i3]), sc_)

            push!(
                data,
                Nucleus.Dict.merge(
                    point,
                    Dict(
                        "x" => view(di_x_po_x_co, 1, i2_),
                        "y" => view(di_x_po_x_co, 2, i2_),
                        "text" => view(po_, i2_),
                        "marker" => Dict("color" => he_[i3]),
                    ),
                ),
            )

        end

    end

    axis = Dict(
        "range" => (-1, 1),
        "showgrid" => false,
        "zeroline" => false,
        "showticklabels" => false,
        "ticks" => "",
    )

    Nucleus.Plot.plot(
        ht,
        data,
        Dict(
            "height" => size,
            "width" => size,
            "margin" => Dict("t" => margin, "b" => margin, "l" => margin, "r" => margin),
            "xaxis" => axis,
            "yaxis" => axis,
            "showlegend" => false,
        ),
    )

end

end
