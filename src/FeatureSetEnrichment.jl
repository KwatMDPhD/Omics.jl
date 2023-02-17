module FeatureSetEnrichment

using DataFrames: DataFrame

using StatsBase: mean, sample

using ..BioLab

struct KS end

struct KSa end

struct KLi end

struct KLiop end

struct KLiom end

function _get_absolute_raise(sc_, id, ex)

    abe = sc_[id]

    if abe < 0.0

        abe = -abe

    end

    if ex != 1.0

        abe ^= ex

    end

    return abe

end

function _sum_1_and_0(sc_, bo_, ex)

    n = length(sc_)

    su1 = 0.0

    su0 = 0.0

    for id in 1:n

        if bo_[id]

            su1 += _get_absolute_raise(sc_, id, ex)

        else

            su0 += 1.0

        end

    end

    return n, su1, su0

end

function _sum_all_and_1(sc_, bo_, ex)

    n = length(sc_)

    su = 0.0

    su1 = 0.0

    for id in 1:n

        abe = _get_absolute_raise(sc_, id, ex)

        su += abe

        if bo_[id]

            su1 += abe

        end

    end

    return n, su, su1

end

function _range(di_)

    return di_[2] - di_[1]

end

function _plot_mountain(
    fe_,
    sc_,
    bo_,
    en_,
    en;
    title_text = "Mountain Plot",
    fe = "Feature",
    sc = "Score",
    ht = "",
)

    width = 800

    height = width / MathConstants.golden

    yaxis1_domain = (0.0, 0.24)

    yaxis2_domain = (0.24, 0.32)

    yaxis3_domain = (0.32, 1.0)

    title_font_size = 24

    statistic_font_size = 16

    axis_title_font_size = 12

    annotation =
        Dict("yref" => "paper", "xref" => "paper", "yanchor" => "middle", "showarrow" => false)

    annotationy = merge(
        annotation,
        Dict("xanchor" => "right", "x" => -0.064, "font" => Dict("size" => axis_title_font_size)),
    )

    annotationx = merge(annotation, Dict("xanchor" => "center", "x" => 0.5))

    title_text = BioLab.String.limit(title_text, 32)

    n = length(fe_)

    layout = Dict(
        "height" => height,
        "width" => width,
        "margin" => Dict(
            "t" => round(height * 0.24),
            "b" => round(height * 0.088),
            "l" => round(width * 0.19),
        ),
        "showlegend" => false,
        "yaxis" => Dict("domain" => yaxis1_domain, "showline" => true, "showgrid" => false),
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
                    "y" => 1.29,
                    "text" => "<b>$title_text</b>",
                    "font" => Dict("size" => title_font_size, "color" => "#2b2028"),
                ),
            ),
            merge(
                annotationx,
                Dict(
                    "y" => 1.16,
                    "text" => "Enrichment: <b>$(BioLab.Number.format(en))</b>",
                    "font" => Dict("size" => statistic_font_size, "color" => "#181b26"),
                    "bgcolor" => "#ebf6f7",
                    "bordercolor" => "#404ed8",
                    "borderpad" => 6.4,
                ),
            ),
            merge(annotationy, Dict("y" => mean(yaxis1_domain), "text" => "<b>$sc</b>")),
            merge(annotationy, Dict("y" => mean(yaxis2_domain), "text" => "<b>Set</b>")),
            merge(annotationy, Dict("y" => mean(yaxis3_domain), "text" => "<b>Enrichment</b>")),
            merge(
                annotationx,
                Dict(
                    "y" => -0.088,
                    "text" => "<b>$fe (n=$n)</b>",
                    "font" => Dict("size" => axis_title_font_size),
                ),
            ),
        ),
    )

    x = collect(1:n)

    trace_ = [
        Dict(
            "y" => sc_,
            "x" => x,
            "text" => fe_,
            "mode" => "lines",
            "line" => Dict("width" => 0.0),
            "fill" => "tozeroy",
            "fillcolor" => "#20d9ba",
            "hoverinfo" => "x+y+text",
        ),
        Dict(
            "yaxis" => "y2",
            "y" => fill(0, sum(bo_)),
            "x" => x[bo_],
            "text" => fe_[bo_],
            "mode" => "markers",
            "marker" => Dict(
                "symbol" => "line-ns",
                "size" => height * _range(yaxis2_domain) * 0.32,
                "line" => Dict("width" => 2.4, "color" => "#9017e6"),
            ),
            "hoverinfo" => "x+text",
        ),
    ]

    le_ = (en < 0.0 for en in en_)

    for (is_, fillcolor) in ((le_, "#1992ff"), ((!le for le in le_), "#ff1993"))

        push!(
            trace_,
            Dict(
                "yaxis" => "y3",
                "y" => [ifelse(is, en, 0.0) for (is, en) in zip(is_, en_)],
                "x" => x,
                "text" => fe_,
                "mode" => "lines",
                "line" => Dict("width" => 0.0),
                "fill" => "tozeroy",
                "fillcolor" => fillcolor,
                "hoverinfo" => "x+y+text",
            ),
        )

    end

    ex_ = BioLab.VectorNumber.get_extreme(en_)

    id_ = findall(en in ex_ for en in en_)

    push!(
        trace_,
        Dict(
            "yaxis" => "y3",
            "y" => en_[id_],
            "x" => x[id_],
            "mode" => "markers",
            "marker" => Dict(
                "symbol" => "circle",
                "size" => height * _range(yaxis3_domain) * 0.04,
                "color" => "#ebf6f7",
                "opacity" => 0.72,
                "line" => Dict("width" => 2.0, "color" => "#404ed8", "opacity" => 0.88),
            ),
            "hoverinfo" => "y",
        ),
    )

    return BioLab.Plot.plot(trace_, layout; ht)

end

end
