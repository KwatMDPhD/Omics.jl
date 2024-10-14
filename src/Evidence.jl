module Evidence

using ..Omics

function get_evidence(p1, p1f)

    log2(Omics.Probability.get_odd(p1f) / Omics.Probability.get_odd(p1))

end

function get_posterior_probability(p1, ev)

    Omics.Probability.get_probability(Omics.Probability.get_odd(p1) * exp2(ev))

end

function _range(mi, ma, ex)

    ex *= ma - mi

    mi - ex, ma + ex

end

function plot(ht, ns, sa_, nt, ta_, nf, fe_, p1f_, lo_, up_; si = 4)

    id_ = sortperm(fe_)

    sa_ = sa_[id_]

    ta_ = ta_[id_]

    fe_ = fe_[id_]

    # TODO: Consider sorting p1f_.

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
            Dict(
                "yaxis" => "y3",
                "y" => (0.5, 0.5),
                "x" => (sa_[1], sa_[end]),
                "mode" => "lines",
                "line" => Dict("color" => Omics.Color.GR),
            ),
        ),
        Dict(
            "showlegend" => false,
            "yaxis" => Dict("domain" => (0.98, 1), "ticks" => ""),
            "yaxis2" => Dict(
                "domain" => (0, 0.96),
                "position" => 0,
                "title" => Dict("text" => nf, "font" => Dict("color" => hd)),
                "range" => _range(extrema(fe_)..., 0.04),
                "tickvals" => Omics.Plot.make_tickvals(fe_),
            ),
            "yaxis3" => Dict(
                "overlaying" => "y2",
                "title" =>
                    Dict("text" => "Probability of $nt", "font" => Dict("color" => hf)),
                "range" => _range(0, 1, 0.04),
                "tickvals" => (0, 0.5, 1),
            ),
            "xaxis" => Dict(
                "anchor" => "y2",
                "domain" => (0.08, 1),
                "title" => Dict("text" => ns),
                "ticks" => "",
            ),
        ),
    )

end

function _root(ev)

    sign(ev) * sqrt(abs(ev))

end

function _color(ev)

    if ev < 0

        Omics.Color.RE

    elseif iszero(ev)

        "#000000"

    else

        Omics.Color.GR

    end

end

function _make(yc, xc, te, si, hm, wi, hl = hm)

    li = Dict("width" => wi, "color" => hl)

    [
        Dict(
            "legendgroup" => yc,
            "y" => (yc, yc),
            "x" => (0, xc),
            "mode" => "lines",
            "line" => li,
        ),
        Dict(
            "legendgroup" => yc,
            "y" => (yc,),
            "x" => (xc,),
            "text" => te,
            "mode" => "markers+text",
            "marker" => Dict("size" => si, "color" => hm, "line" => li),
            "textposition" => xc < 0 ? "left" : "right",
            "textfont" => Dict("size" => si * 0.8),
        ),
    ]

end

function _make(::Integer, ::Integer, ac::Nothing, ::Real)

    Dict{String, Any}()

end

function _make(yc, xe, ac, si)

    xc, tr, te = ac ? (xe, "right", "left") : (-xe, "left", "right")

    Dict(
        "y" => (yc,),
        "x" => (xc,),
        "mode" => "markers+text",
        "marker" => Dict("symbol" => "triangle-$tr", "size" => si, "color" => _color(xc)),
        "text" => "Actual",
        "textfont" => Dict("size" => si * 0.8),
        "textposition" => te,
    )

end

function plot(ht, nt, p1, nf_, p1f_, ac = nothing; xe = 8)

    be = log2(Omics.Probability.get_odd(p1))

    ev_ = [get_evidence(p1, p1f) for p1f in p1f_]

    af = reduce(+, ev_; init = be)

    be = _root(be)

    map!(_root, ev_, ev_)

    af = _root(af)

    ye = lastindex(nf_) + 1

    yi, ya = _range(0, ye, 0.064)

    wi = 4

    he = "#000000"

    si = 20

    ie_ = eachindex(nf_)

    he_ = Omics.Palette.color(ie_)

    ti_ = (-xe):xe

    Omics.Plot.plot(
        ht,
        [
            Dict(
                "y" => (yi,),
                "x" => (0,),
                "marker" => Dict("symbol" => "triangle-up", "size" => 24, "color" => he),
            )
            Dict(
                "y" => (yi, ya),
                "x" => (0, 0),
                "mode" => "lines",
                "line" => Dict("width" => wi, "color" => he),
            )
            Dict(
                "y" => (ya, ya),
                "x" => (-xe, xe),
                "mode" => "lines",
                "line" => Dict("width" => wi, "color" => he),
            )
            _make(0, be, "Prior", si, _color(be), wi)
            (_make(ie, ev_[ie], nf_[ie], si, he_[ie], wi) for ie in ie_)...
            _make(ye, af, "Total", si * 1.6, _color(af), wi, he)
            _make(ye, xe, ac, si)
        ],
        Dict(
            "width" => Omics.Plot.SI,
            "margin" => Dict("b" => 0),
            "showlegend" => false,
            "yaxis" => Dict("visible" => false),
            "xaxis" => Dict(
                "side" => "top",
                "title" => Dict("text" => "Evidence for $nt", "standoff" => 40),
                "range" => _range(-xe, xe, 0.02),
                "tickvals" => ti_,
                "ticktext" => map(
                    ev ->
                        "$ev | $(Omics.Strin.shorten(get_posterior_probability(p1, ev)))",
                    ti_,
                ),
                "tickangle" => -90,
                "ticks" => "inside",
                "ticklen" => 16,
                "tickwidth" => 2,
                "tickcolor" => Omics.Color.FA,
            ),
        ),
    )

end

end
