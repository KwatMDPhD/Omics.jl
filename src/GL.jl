module GL

using GLM: @formula, Binomial, glm, predict

using ..Omics

function fit(ta_, fe_)

    glm(@formula(ta ~ fe), (ta = ta_, fe = fe_), Binomial())

end

function predic(gl, fe_)

    predict(gl, (fe = fe_,); interval = :confidence)

end

function predic(gl, fe::Real)

    pr_, lo_, up_ = predic(gl, [fe])

    pr_[], lo_[], up_[]

end

function plot(ht, ns, sa_, nt, ta_, nf, fe_, pr_, lo_, up_; si = 2)

    hd = Omics.Color.RE

    hf = Omics.Color.BL

    bo = Dict("yaxis" => "y3", "x" => sa_, "mode" => "lines", "line" => Dict("width" => 0))

    dm = 0.96

    ex = 0.032

    Omics.Plot.plot(
        ht,
        (
            Dict(
                "type" => "heatmap",
                "y" => (nt,),
                "x" => sa_,
                "z" => (ta_,),
                "colorscale" => Omics.Palette.fractionate(Omics.Palette.BI),
                "showscale" => false,
            ),
            Dict(
                "yaxis" => "y2",
                "y" => fe_,
                "x" => sa_,
                "mode" => "markers",
                "marker" => Dict("size" => si * 2, "color" => hd),
            ),
            Dict(
                "yaxis" => "y3",
                "y" => (0.5, 0.5),
                "x" => (sa_[1], sa_[end]),
                "mode" => "lines",
                "line" => Dict("width" => 1.64, "color" => "#000000"),
            ),
            merge(bo, Dict("y" => lo_)),
            merge(
                bo,
                Dict(
                    "y" => up_,
                    "fill" => "tonexty",
                    "fillcolor" => Omics.Color.hexify(hf, 0.16),
                ),
            ),
            Dict(
                "yaxis" => "y3",
                "y" => pr_,
                "x" => sa_,
                "marker" => Dict("size" => si, "color" => hf),
            ),
        ),
        Dict(
            "showlegend" => false,
            "yaxis" => Dict("domain" => (dm, 1), "ticks" => ""),
            "yaxis2" => Dict(
                "domain" => (0, dm),
                "position" => 0,
                "title" => Dict("text" => nf, "font" => Dict("color" => hd)),
                "range" => Omics.Plot.rang(extrema(fe_)..., ex),
                "tickvals" => map(Omics.Strin.shorten, Omics.Plot.make_tickvals(fe_)),
            ),
            "yaxis3" => Dict(
                "overlaying" => "y2",
                "position" => 0.112,
                "title" =>
                    Dict("text" => "Probability of $nt", "font" => Dict("color" => hf)),
                "range" => Omics.Plot.rang(0, 1, ex),
                "tickvals" => (0, 1, map(Omics.Strin.shorten, extrema(pr_))...),
            ),
            "xaxis" => Dict(
                "anchor" => "y2",
                "domain" => (0.08, 1),
                "title" => Dict("text" => "$ns ($(lastindex(ta_)))"),
                "ticks" => "",
            ),
        ),
    )

end

end
