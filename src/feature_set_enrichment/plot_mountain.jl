function plot_mountain(
    fe_,
    sc_,
    in_,
    en_,
    en;
    height = 480,
    title_text = "Mountain Plot",
    title_font_size = 24,
    axis_title_font_size = 12,
    names = "Score",
    line_width = 2.0,
    ou = "",
)

    width = height * MathConstants.golden

    yaxis1_domain = [0.0, 0.24]

    yaxis2_domain = [0.24, 0.32]

    yaxis3_domain = [0.32, 1.0]

    annotation = Config(xref = "paper", yref = "paper", yanchor = "middle", showarrow = false)

    annotationy =
        merge(annotation, Config(xanchor = "right", x = -0.064, font_size = axis_title_font_size))

    annotationx = merge(annotation, Config(xanchor = "center", x = 0.5))

    namee = "Enrichment"

    en = @sprintf "%.3f" en

    n_fe = length(fe_)

    layout = Config(
        height = height,
        width = width,
        margin = Config(t = trunc(height * 0.16), l = trunc(width * 0.16)),
        legend = Config(
            orientation = "h",
            yanchor = "middle",
            xanchor = "center",
            y = -0.2,
            x = 0.5,
        ),
        yaxis1 = Config(domain = yaxis1_domain, showline = true),
        yaxis2 = Config(domain = yaxis2_domain, showticklabels = false, showgrid = false),
        yaxis3 = Config(domain = yaxis3_domain, showline = true),
        xaxis = Config(
            zeroline = false,
            showspikes = true,
            spikethickness = 0.8,
            spikedash = "solid",
            spikemode = "across",
        ),
        annotations = [
            merge(
                annotationx,
                Config(
                    y = 1.16,
                    text = string("<b>", title_text, "</b>"),
                    font_size = title_font_size,
                ),
            ),
            merge(
                annotationx,
                Config(
                    y = 1.04,
                    text = string("<b>Score = ", en, "</b>"),
                    font = Config(size = title_font_size * 0.64, color = "2a603b"),
                ),
            ),
            merge(
                annotationy,
                Config(
                    y = OnePiece.geometry.get_center(yaxis1_domain...),
                    text = string("<b>", names, "</b>"),
                ),
            ),
            merge(
                annotationy,
                Config(y = OnePiece.geometry.get_center(yaxis2_domain...), text = "<b>Set</b>"),
            ),
            merge(
                annotationy,
                Config(
                    y = OnePiece.geometry.get_center(yaxis3_domain...),
                    text = string("<b>", namee, "</b>"),
                ),
            ),
            merge(
                annotationx,
                Config(y = -0.088, text = string("<b>Feature Rank (n=", n_fe, ")</b>")),
            ),
        ],
    )

    x = 1:n_fe

    tracef = Config(
        type = "scatte",
        name = names,
        y = sc_,
        x = x,
        text = fe_,
        mode = "lines",
        line = Config(width = 0, color = "20d8ba"),
        fill = "tozeroy",
        hoverinfo = "x+y+text",
    )

    in_ = convert(BitVector, in_)

    traces = Config(
        type = "scatte",
        name = "Set",
        yaxis = "y2",
        y = zeros(sum(in_)),
        x = x[in_],
        text = fe_[in_],
        mode = "markers",
        marker = Config(
            symbol = "line-ns-open",
            size = height * (yaxis2_domain[2] - yaxis2_domain[1]) * 0.64,
            line_width = line_width,
            color = "9017e6",
        ),
        hoverinfo = "x+text",
    )

    trace_ = [tracef, traces]

    for (name, is_, color) in
        [["- Enrichment", en_ .< 0.0, "0088ff"], ["+ Enrichment", 0.0 .< en_, "ff1968"]]

        push!(
            trace_,
            Config(
                type = "scatte",
                name = name,
                yaxis = "y3",
                y = ifelse.(is_, en_, 0.0),
                x = x,
                text = fe_,
                mode = "lines",
                line = Config(width = 0.0, color = color),
                fill = "tozeroy",
                hoverinfo = "x+y+text",
            ),
        )

    end

    OnePiece.figure.plot(trace_, layout, ou = ou)

end
