function _ro(fl)

    fl = round(fl, sigdigits = 2)

    if abs(fl) < eps()

        fl = 0.0

    end

    "<b>$fl</b>"

end

function _plot_mountain(fe_, sc_, in_, en_, (ex, ar); title_text = "Mountain Plot", ou = "")

    height = 800

    width = height * MathConstants.golden

    yaxis1_domain = (0.0, 0.24)

    yaxis2_domain = (0.24, 0.32)

    yaxis3_domain = (0.32, 1.0)

    annotation =
        Dict("xref" => "paper", "yref" => "paper", "yanchor" => "middle", "showarrow" => false)

    axis_title_font_size = 16

    annotationy = merge(
        annotation,
        Dict("xanchor" => "right", "x" => -0.064, "font" => Dict("size" => axis_title_font_size)),
    )

    annotationx = merge(annotation, Dict("xanchor" => "center", "x" => 1 / 2))

    n_ch = 32

    if n_ch < length(title_text)

        title_text = "$(title_text[1:n_ch])..."

    end

    n_fe = length(fe_)

    layout = Dict(
        "height" => height,
        "width" => width,
        "margin" => Dict("t" => trunc(height * 0.16), "l" => trunc(width * 0.16)),
        "showlegend" => false,
        "yaxis1" => Dict("domain" => yaxis1_domain, "showline" => true, "showgrid" => false),
        "yaxis2" =>
            Dict("domain" => yaxis2_domain, "showticklabels" => false, "showgrid" => false),
        "yaxis3" => Dict("domain" => yaxis3_domain, "showline" => true, "showgrid" => false),
        "xaxis" => Dict(
            "zeroline" => false,
            "showgrid" => false,
            "showspikes" => true,
            "spikethickness" => 1.08,
            "spikecolor" => "#ffb61e",
            "spikedash" => "solid",
            "spikemode" => "across",
        ),
        "annotations" => (
            merge(
                annotationx,
                Dict(
                    "y" => 1.16,
                    "text" => "<b>$title_text</b>",
                    "font" => Dict("size" => 32, "color" => "#2b2028"),
                ),
            ),
            merge(
                annotationx,
                Dict(
                    "y" => 1.04,
                    "text" => "Extreme = $(_ro(ex)) and Area = $(_ro(ar))",
                    "font" => Dict("size" => 24, "color" => "#181b26"),
                    "bgcolor" => "#ebf6f7",
                    "bordercolor" => "#404ed8",
                    "borderpad" => 6.4,
                ),
            ),
            merge(
                annotationy,
                Dict(
                    "y" => OnePiece.geometry.get_center(yaxis1_domain...),
                    "text" => "<b>Feature</b>",
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
                    "text" => "<b>Enrichment</b>",
                ),
            ),
            merge(
                annotationx,
                Dict(
                    "y" => -0.088,
                    "text" => "<b>Feature (n=$n_fe)</b>",
                    "font" => Dict("size" => axis_title_font_size),
                ),
            ),
        ),
    )

    x = 1:n_fe

    tracef = Dict(
        "y" => sc_,
        "x" => x,
        "text" => fe_,
        "mode" => "lines",
        "line" => Dict("width" => 0),
        "fill" => "tozeroy",
        "fillcolor" => "#20d9ba",
        "hoverinfo" => "x+y+text",
    )

    in_ = convert(BitVector, in_)

    traces = Dict(
        "yaxis" => "y2",
        "y" => zeros(sum(in_)),
        "x" => x[in_],
        "text" => fe_[in_],
        "mode" => "markers",
        "marker" => Dict(
            "symbol" => "line-ns",
            "size" => height * (yaxis2_domain[2] - yaxis2_domain[1]) * 0.32,
            "line" => Dict("width" => 2.4, "color" => "#9017e6"),
        ),
        "hoverinfo" => "x+text",
    )

    trace_ = [tracef, traces]

    for (is_, fillcolor) in ((en_ .< 0.0, "#1992ff"), (0.0 .< en_, "#ff1993"))

        push!(
            trace_,
            Dict(
                "yaxis" => "y3",
                "y" => ifelse.(is_, en_, 0.0),
                "x" => x,
                "text" => fe_,
                "mode" => "lines",
                "line" => Dict("width" => 0),
                "fill" => "tozeroy",
                "fillcolor" => fillcolor,
                "hoverinfo" => "x+y+text",
            ),
        )

    end

    id_ = findall(en_ .== ex)

    push!(
        trace_,
        Dict(
            "yaxis" => "y3",
            "y" => en_[id_],
            "x" => x[id_],
            "mode" => "markers",
            "marker" => Dict(
                "symbol" => "circle",
                "size" => height * (yaxis3_domain[2] - yaxis3_domain[1]) * 0.04,
                "color" => "#ebf6f7",
                "opacity" => 0.72,
                "line" => Dict("width" => 2, "color" => "#404ed8", "opacity" => 1),
            ),
            "hoverinfo" => "y",
        ),
    )

    OnePiece.figure.plot(trace_, layout, ou = ou)

end
