module GeneralizedLinearModel

using GLM: @formula, Binomial, glm, predict

using ..Omics

# TODO: Generalize

function fit(ta_, fe_)

    glm((@formula ta ~ fe), (ta = ta_, fe = fe_), Binomial())

end

function predic(gl, fe_)

    predict(gl, (fe = fe_,); interval = :confidence)

end

function predic(gl, fe::Real)

    pr_, lo_, up_ = predic(gl, [fe])

    pr_[], lo_[], up_[]

end

function plot(
    ht,
    ns,
    sa_,
    nt,
    ta_,
    nf,
    fe_,
    pr_,
    lo_,
    up_;
    si = 4,
    wi = 4,
    la = Dict{String, Any}(),
)

    hd = Omics.Color.VI

    hp = Omics.Color.TU

    bo = Dict("yaxis" => "y3", "x" => sa_, "mode" => "lines", "line" => Dict("width" => 0))

    di = 0.96

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
                "marker" => Dict("size" => si, "color" => hd),
            ),
            Dict(
                "yaxis" => "y3",
                "y" => (0.5, 0.5),
                "x" => (sa_[1], sa_[end]),
                "mode" => "lines",
                "line" => Dict("width" => wi * 0.5, "color" => "#000000"),
            ),
            merge(bo, Dict("y" => lo_)),
            merge(
                bo,
                Dict(
                    "y" => up_,
                    "fill" => "tonexty",
                    "fillcolor" => Omics.Color.hexify(hp, 0.16),
                ),
            ),
            merge(bo, Dict("y" => pr_, "line" => Dict("width" => wi, "color" => hp))),
        ),
        Omics.Dic.merg(
            Dict(
                "showlegend" => false,
                "yaxis" => Dict("domain" => (di, 1.0), "ticks" => ""),
                "yaxis2" => Dict(
                    "domain" => (0.0, di),
                    "position" => 0,
                    "title" => Dict("text" => nf, "font" => Dict("color" => hd)),
                    "range" => Omics.Plot.rang(extrema(fe_)..., ex),
                    "tickvals" => map(Omics.Numbe.shorten, Omics.Plot.tick(fe_)),
                ),
                "yaxis3" => Dict(
                    "overlaying" => "y2",
                    "position" => 0.112,
                    "title" => Dict(
                        "text" => "Probability of $nt",
                        "font" => Dict("color" => hp),
                    ),
                    "range" => Omics.Plot.rang(0, 1, ex),
                    "tickvals" => (0.0, map(Omics.Numbe.shorten, extrema(pr_))..., 1.0),
                ),
                "xaxis" => Dict(
                    "anchor" => "y2",
                    "domain" => (0.08, 1.0),
                    "title" => Dict("text" => "$ns ($(lastindex(ta_)))"),
                    "ticks" => "",
                ),
            ),
            la,
        ),
    )

end

end
