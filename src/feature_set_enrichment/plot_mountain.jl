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

    annotation =
        Dict("xref" => "paper", "yref" => "paper", "yanchor" => "middle", "showarrow" => false)

    annotationy = merge(
        annotation,
        Dict("xanchor" => "right", "x" => -0.064, "font_size" => axis_title_font_size),
    )

    annotationx = merge(annotation, Dict("xanchor" => "center", "x" => 0.5))

    namee = "Enrichment"

    en = @sprintf "%.3f" en

    n_fe = length(fe_)

    layout = Dict(
        "height" => height,
        "width" => width,
        "margin" => Dict("t" => trunc(height * 0.16), "l" => trunc(width * 0.16)),
        "legend" => Dict(
            "orientation" => "h",
            "yanchor" => "middle",
            "xanchor" => "center",
            "y" => -0.2,
            "x" => 0.5,
        ),
        "yaxis1" => Dict("domain" => yaxis1_domain, "showline" => true),
        "yaxis2" =>
            Dict("domain" => yaxis2_domain, "showticklabels" => false, "showgrid" => false),
        "yaxis3" => Dict("domain" => yaxis3_domain, "showline" => true),
        "xaxis" => Dict(
            "zeroline" => false,
            "showspikes" => true,
            "spikethickness" => 0.8,
            "spikedash" => "solid",
            "spikemode" => "across",
        ),
        "annotations" => [
            merge(
                annotationx,
                Dict("y" => 1.16, "text" => "<b>$title_text</b>", "font_size" => title_font_size),
            ),
            merge(
                annotationx,
                Dict(
                    "y" => 1.04,
                    "text" => "<b>Score = $en</b>",
                    "font" => Dict("size" => title_font_size * 0.64, "color" => "2a603b"),
                ),
            ),
            merge(
                annotationy,
                Dict(
                    "y" => OnePiece.geometry.get_center(yaxis1_domain...),
                    "text" => "<b>$names</b>",
                ),
            ),
            merge(
                annotationy,
                Dict(
                    "y" => OnePiece.geometry.get_center(yaxis2_domain...),
                    "text" => "<b>Set</b>",
                ),
            ),
            merge(
                annotationy,
                Dict(
                    "y" => OnePiece.geometry.get_center(yaxis3_domain...),
                    "text" => "<b>$namee</b>",
                ),
            ),
            merge(annotationx, Dict("y" => -0.088, "text" => "<b>Feature Rank (n=$n_fe)</b>")),
        ],
    )

    x = 1:n_fe

    tracef = Dict(
        "type" => "scatter",
        "name" => names,
        "y" => sc_,
        "x" => x,
        "text" => fe_,
        "mode" => "lines",
        "line" => Dict("width" => 0, "color" => "20d9ba"),
        "fill" => "tozeroy",
        "hoverinfo" => "x+y+text",
    )

    in_ = convert(BitVector, in_)

    traces = Dict(
        "type" => "scatter",
        "name" => "Set",
        "yaxis" => "y2",
        "y" => zeros(sum(in_)),
        "x" => x[in_],
        "text" => fe_[in_],
        "mode" => "markers",
        "marker" => Dict(
            "symbol" => "line-ns-open",
            "size" => height * (yaxis2_domain[2] - yaxis2_domain[1]) * 0.64,
            "line_width" => line_width,
            "color" => "9017e6",
        ),
        "hoverinfo" => "x+text",
    )

    trace_ = [tracef, traces]

    for (name, is_, color) in
        [["- Enrichment", en_ .< 0.0, "0088ff"], ["+ Enrichment", 0.0 .< en_, "ff1968"]]

        push!(
            trace_,
            Dict(
                "type" => "scatter",
                "name" => name,
                "yaxis" => "y3",
                "y" => ifelse.(is_, en_, 0.0),
                "x" => x,
                "text" => fe_,
                "mode" => "lines",
                "line" => Dict("width" => 0.0, "color" => color),
                "fill" => "tozeroy",
                "hoverinfo" => "x+y+text",
            ),
        )

    end

    OnePiece.figure.plot(trace_, layout, ou = ou)

end
