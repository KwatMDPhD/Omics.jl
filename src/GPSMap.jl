module GPSMap

using KernelDensity: default_bandwidth, kde

using ..Omics

function _estimate(nu___; ke_ar...)

    de = kde(nu___; ke_ar...)

    de.x, de.y, de.density

end

function plot(
    ht,
    no_,
    cn,
    po_,
    cp;
    node_marker_size = 56,
    node_marker_color = "#000000",
    node_marker_line_width = 2,
    node_marker_line_color = Omics.Color.LI,
    node_annotation_font_size = 24,
    node_annotation_font_color = "#ffffff",
    ug = 128,
    ncontours = 40,
    point_marker_size = 16,
    point_marker_opacity = 0.8,
    point_marker_color = Omics.Color.LI,
    point_marker_line_width = 1,
    point_marker_line_color = "#000000",
    vt_ = nothing,
    ba = 1,
    size = 832,
    margin = 0.04,
)

    data = [
        Dict(
            "showlegend" => false,
            "x" => (0,),
            "y" => (0,),
            "mode" => "markers",
            "marker" => Dict(
                "size" => size - size * margin * 2,
                "color" => Omics.Color.hexify("#ffffff", 0),
                "line" => Dict("width" => 4, "color" => node_marker_color),
            ),
            "cliponaxis" => false,
            "hoverinfo" => "skip",
        ),
    ]

    push!(
        data,
        Dict(
            "showlegend" => false,
            "x" => view(cn, 1, :),
            "y" => view(cn, 2, :),
            "text" => no_,
            "mode" => "markers+text",
            "marker" => Dict(
                "size" => node_marker_size,
                "color" => node_marker_color,
                "line" => Dict(
                    "width" => node_marker_line_width,
                    "color" => node_marker_line_color,
                ),
            ),
            "textfont" => Dict(
                "family" => "Gravitas One, monospace",
                "size" => node_annotation_font_size,
                "color" => node_annotation_font_color,
            ),
            "cliponaxis" => false,
        ),
    )

    ke_ar = (
        boundary = ((-2, 2), (-2, 2)),
        npoints = (ug, ug),
        bandwidth = (
            default_bandwidth(view(cp, 1, :)) * ba,
            default_bandwidth(view(cp, 2, :)) * ba,
        ),
    )

    xc_, yc_, cc = _estimate((view(cp, 1, :), view(cp, 2, :)); ke_ar...)

    aa = [1 < xc^2 + yc^2 for xc in xc_, yc in yc_]

    cc[aa] .= NaN

    push!(
        data,
        Dict(
            "showlegend" => false,
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
        "name" => "Point",
        "x" => view(cp, 1, :),
        "y" => view(cp, 2, :),
        "text" => po_,
        "mode" => "markers",
        "marker" => Dict(
            "size" => point_marker_size,
            "opacity" => point_marker_opacity,
            "color" => point_marker_color,
            "line" => Dict(
                "width" => point_marker_line_width,
                "color" => point_marker_line_color,
            ),
        ),
    )

    if isnothing(vt_)

        push!(data, point)

    elseif vt_ isa AbstractVector{<:AbstractFloat}

        push!(
            data,
            Omics.Dic.merg(
                point,
                Dict(
                    "marker" =>
                        Dict("color" => Omics.Palette.color(vt_, Omics.Palette.bwr)),
                ),
            ),
        )

    else

        tu_ = unique(vt_)

        gr_x_gr_x_id_x_de = Array{Float64, 3}(undef, ug, ug, lastindex(tu_))

        for id in eachindex(tu_)

            ii_ = findall(==(tu_[id]), vt_)

            _xc_, _yc_, cc = _estimate((view(cp, 1, ii_), view(cp, 2, ii_)); ke_ar...)

            cc[aa] .= NaN

            gr_x_gr_x_id_x_de[:, :, id] = cc

        end

        for i2 in 1:ug, i1 in 1:ug

            de_ = view(gr_x_gr_x_id_x_de, i1, i2, :)

            if all(isnan, de_)

                continue

            end

            ma = argmax(de_)

            for id in eachindex(de_)

                if id != ma

                    de_[id] = NaN

                end

            end

        end

        he_ = Omics.Palette.color(eachindex(tu_))

        for id in eachindex(tu_)

            push!(
                data,
                Dict(
                    "legendgroup" => tu_[id],
                    "name" => tu_[id],
                    "type" => "heatmap",
                    "x" => xc_,
                    "y" => yc_,
                    "z" => view(gr_x_gr_x_id_x_de, :, :, id),
                    "colorscale" =>
                        Omics.Palette.fractionate(Omics.Palette.make(["#ffffff", he_[id]])),
                    "showscale" => false,
                    "hoverinfo" => "skip",
                ),
            )

            ii_ = findall(==(tu_[id]), vt_)

            push!(
                data,
                Omics.Dic.merg(
                    point,
                    Dict(
                        "legendgroup" => tu_[id],
                        "name" => tu_[id],
                        "x" => view(cp, 1, ii_),
                        "y" => view(cp, 2, ii_),
                        "text" => view(po_, ii_),
                        "marker" => Dict("color" => he_[id]),
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

    return Omics.Plot.plot(
        ht,
        data,
        Dict(
            "height" => size,
            "width" => size * 1.5,
            "margin" => Dict(
                "autoexpand" => false,
                "t" => size * margin,
                "b" => size * margin,
                "l" => size * margin,
                "r" => size * (margin + 0.5),
            ),
            "xaxis" => axis,
            "yaxis" => axis,
            "legend" => Dict(
                # TODO: `xref`.
                "xanchor" => "right",
                "x" => 1 + 1 / (2 - margin * 4),
            ),
        ),
    )

end

end
