module GL

using GLM: @formula, Binomial, glm, predict

using ..Omics

function fit(ta_, fe_)

    @assert issorted(fe_)

    gl = glm(@formula(ta ~ fe), (ta = ta_, fe = fe_), Binomial())

    p1f_, lo_, up_ =
        predict(gl, (fe = range(fe_[1], fe_[end], lastindex(fe_)),); interval = :confidence)

    gl, convert(Vector{Float64}, p1f_), lo_, up_

end

function plot(ht, ns, sa_, nt, ta_, nf, fe_, p1f_, lo_, up_; si = 2)

    hd = Omics.Color.RE

    hf = Omics.Color.BL

    bo = Dict("yaxis" => "y3", "x" => sa_, "mode" => "lines", "line" => Dict("width" => 0))

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
                "line" => Dict("width" => 1.6, "color" => "#000000"),
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
                "y" => p1f_,
                "x" => sa_,
                "marker" => Dict("size" => si, "color" => hf),
            ),
        ),
        Dict(
            "showlegend" => false,
            "yaxis" => Dict("domain" => (0.98, 1), "ticks" => ""),
            "yaxis2" => Dict(
                "domain" => (0, 0.96),
                "position" => 0,
                "title" => Dict("text" => nf, "font" => Dict("color" => hd)),
                "range" => Omics.Plot.rang(extrema(fe_)..., 0.04),
                "tickvals" => Omics.Plot.make_tickvals(fe_),
            ),
            "yaxis3" => Dict(
                "overlaying" => "y2",
                "title" =>
                    Dict("text" => "Probability of $nt", "font" => Dict("color" => hf)),
                "range" => Omics.Plot.rang(0, 1, 0.04),
                "tickvals" => (0, 0.5, 1),
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
