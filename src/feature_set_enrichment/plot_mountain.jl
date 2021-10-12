using PlotlyJS: Layout, attr, scatter
using Printf: @sprintf

using ..figure: plot

function plot_mountain(
    fe_::VS,
    sc_::VF,
    in_::VF,
    en_::VF,
    en::Float64;
    width::Real = 800,
    height::Real = 500,
    line_width::Real = 2.0,
    title::String = "Score Set",
    title_font_size::Real = 24,
    axis_title_font_size::Real = 12,
    element_score_name::String = "Element Score",
)::Any

    n_fe = length(fe_)

    yaxis1_domain = [0.0, 0.24]

    yaxis2_domain = [0.24, 0.32]

    yaxis3_domain = [0.32, 1.0]

    an = attr(
        xref = "paper",
        yref = "paper",
        yanchor = "middle",
        showarrow = false,
    )

    xa = merge(an, attr(xanchor = "center", x = 0.5))

    ya = merge(
        an,
        attr(xanchor = "right", x = -0.08, font_size = axis_title_font_size),
    )

    layout = Layout(
        width = width,
        height = height,
        margin_l = width * 0.2,
        margin_t = height * 0.2,
        legend_orientation = "h",
        legend_xanchor = "center",
        legend_yanchor = "middle",
        legend_x = 0.5,
        legend_y = -0.24,
        xaxis_zeroline = false,
        xaxis_showspikes = true,
        xaxis_spikethickness = 0.8,
        xaxis_spikedash = "solid",
        xaxis_spikemode = "across",
        yaxis1_domain = yaxis1_domain,
        yaxis1_showline = true,
        yaxis2_domain = yaxis2_domain,
        yaxis2_showticklabels = false,
        yaxis2_showgrid = false,
        yaxis3_domain = yaxis3_domain,
        yaxis3_showline = true,
        annotations = [
            merge(
                xa,
                attr(
                    y = 1.24,
                    text = "<b>$title</b>",
                    font_size = title_font_size,
                ),
            ),
            merge(xa, attr(y = -0.088, text = "<b>Element Rank (n=$n_fe)</b>")),
            merge(
                ya,
                attr(
                    y = get_center(yaxis1_domain...),
                    text = "<b>$element_score_name</b>",
                ),
            ),
            merge(
                ya,
                attr(y = get_center(yaxis2_domain...), text = "<b>Set</b>"),
            ),
            merge(
                ya,
                attr(
                    y = get_center(yaxis3_domain...),
                    text = "<b>Set Score</b>",
                ),
            ),
        ],
    )

    x = 1:n_fe

    tre = scatter(
        name = "Element Score",
        x = x,
        y = sc_,
        text = fe_,
        line_width = line_width,
        line_color = "#4e40d8",
        fill = "tozeroy",
        hoverinfo = "x+y+text",
    )

    in_ = BitVector(in_)

    tr1 = scatter(
        name = "Set",
        yaxis = "y2",
        mode = "markers",
        x = x[in_],
        y = zeros(Int64(sum(in_))),
        text = fe_[in_],
        marker_symbol = "line-ns-open",
        marker_size = height * (yaxis2_domain[2] - yaxis2_domain[1]) * 0.64,
        marker_line_width = line_width,
        marker_color = "#9017e6",
        hoverinfo = "x+text",
    )

    en = @sprintf "%.3f" en

    push!(
        layout["annotations"],
        merge(
            xa,
            attr(
                y = 1.16,
                text = "<b>Enrichment = $en</b>",
                font_size = title_font_size * 0.64,
                font_color = "#2a603b",
            ),
        ),
    )

    trs = scatter(
        name = "Set Score",
        yaxis = "y3",
        x = x,
        y = en_,
        text = fe_,
        line_width = line_width,
        line_color = "#20d9ba",
        fill = "tozeroy",
        hoverinfo = "x+y+text",
    )

    print("Displaying")
    return plot([tre, tr1, trs], layout)

end

export plot_mountain
