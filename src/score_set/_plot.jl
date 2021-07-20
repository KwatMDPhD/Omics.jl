using Plotly: Layout, attr, plot, scatter
using Printf: @sprintf

function _plot(
    element_::Vector{String},
    score_::Vector{Float64},
    set_element_::Vector{String},
    is_::Vector{Float64},
    set_score_::Vector{Float64},
    statistic::Float64;
    width::Real = 800,
    height::Real = 500,
    line_width::Real = 2.0,
    title::String = "Score Set",
    title_font_size::Real = 24,
    axis_title_font_size::Real = 12,
    element_score_name::String = "Element Score",
)::Any

    n_element = length(element_)

    yaxis1_domain = (0.0, 0.24)

    yaxis2_domain = (0.24, 0.32)

    yaxis3_domain = (0.32, 1.0)

    annotation_template =
        attr(xref = "paper", yref = "paper", yanchor = "middle", showarrow = false)

    x_annotation_template = merge(annotation_template, attr(xanchor = "center", x = 0.5))

    y_annotation_template = merge(
        annotation_template,
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
                x_annotation_template,
                attr(y = 1.24, text = "<b>$title</b>", font_size = title_font_size),
            ),
            merge(
                x_annotation_template,
                attr(y = -0.088, text = "<b>Element Rank (n=$n_element)</b>"),
            ),
            merge(
                y_annotation_template,
                attr(y = get_center(yaxis1_domain...), text = "<b>$element_score_name</b>"),
            ),
            merge(
                y_annotation_template,
                attr(y = get_center(yaxis2_domain...), text = "<b>Set</b>"),
            ),
            merge(
                y_annotation_template,
                attr(y = get_center(yaxis3_domain...), text = "<b>Set Score</b>"),
            ),
        ],
    )

    x = 1:n_element

    score_trace = scatter(
        name = "Element Score",
        x = x,
        y = score_,
        text = element_,
        line_width = line_width,
        line_color = "#4e40d8",
        fill = "tozeroy",
        hoverinfo = "x+y+text",
    )

    isbit_ = BitVector(is_)

    set_element_trace = scatter(
        name = "Set",
        yaxis = "y2",
        mode = "markers",
        x = x[isbit_],
        y = zeros(Int64(sum(is_))),
        text = element_[isbit_],
        marker_symbol = "line-ns-open",
        marker_size = height * (yaxis2_domain[2] - yaxis2_domain[1]) * 0.64,
        marker_line_width = line_width,
        marker_color = "#9017e6",
        hoverinfo = "x+text",
    )

    statistic = @sprintf "%.3f" statistic

    push!(
        layout["annotations"],
        merge(
            x_annotation_template,
            attr(
                y = 1.16,
                text = "<b>Statistic = $statistic</b>",
                font_size = title_font_size * 0.64,
                font_color = "#2a603b",
            ),
        ),
    )

    set_score_trace = scatter(
        name = "Set Score",
        yaxis = "y3",
        x = x,
        y = set_score_,
        text = element_,
        line_width = line_width,
        line_color = "#20d9ba",
        fill = "tozeroy",
        hoverinfo = "x+y+text",
    )

    return display(plot([score_trace, set_element_trace, set_score_trace], layout))

end

export _plot
