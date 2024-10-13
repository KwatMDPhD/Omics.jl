module Evidence

using ..Omics

function get_evidence(p1, p1f)

    log2(Omics.Probability.get_odd(p1f) / Omics.Probability.get_odd(p1))

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

    dm = 0.98

    Omics.Plot.plot(
        ht,
        (
            Dict(
                "type" => "heatmap",
                "z" => (ta_,),
                "y" => (nt,),
                "x" => sa_,
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
                "y" => p1f_,
                "x" => sa_,
                "marker" => Dict("size" => si, "color" => hf),
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
                "y" => (0.5, 0.5),
                "x" => (sa_[1], sa_[end]),
                "mode" => "lines",
                "line" => Dict("color" => Omics.Color.GR),
            ),
        ),
        Dict(
            "showlegend" => false,
            "yaxis" => Dict("domain" => (dm, 1), "ticks" => ""),
            "yaxis2" => Dict(
                "domain" => (0, dm - 0.02),
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
                "domain" => (0.088, 1),
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

function _make(yc, xc, te, si, wi, hm, hl = hm)

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

function _make(yc, xc, pr, si)

    if iszero(pr)

        xc = -xc

        di = "left"

    elseif isone(pr)

        di = "right"

    end

    Dict(
        "y" => (yc,),
        "x" => (xc,),
        "text" => "Actual",
        "mode" => "markers+text",
        "marker" => Dict("symbol" => "triangle-$di", "size" => si, "color" => _color(xc)),
        "textposition" => xc < 0 ? "right" : "left",
        "textfont" => Dict("size" => si * 0.8),
    )

end

function plot(ht, nt, p1, nf_, p1f_, ac = nothing; xa = 8)

    be = log2(Omics.Probability.get_odd(p1))

    uf = lastindex(nf_)

    ev_ = Vector{Float64}(undef, uf)

    af = be

    for id in eachindex(nf_)

        af += ev_[id] = get_evidence(p1, p1f_[id])

    end

    be = _root(be)

    map!(_root, ev_, ev_)

    af = _root(af)

    yi, ya = _range(0, uf + 1, 0.064)

    wi = 4

    he = "#000000"

    si = 20

    he_ = Omics.Palette.color(1:uf)

    ti_ = (-xa):xa

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
                "x" => (-xa, xa),
                "mode" => "lines",
                "line" => Dict("width" => wi, "color" => he),
            )
            _make(0, be, "Prior", si, wi, _color(be))
            (_make(id, ev_[id], nf_[id], si, wi, he_[id]) for id in eachindex(nf_))...
            _make(uf + 1, af, "Total", si * 1.6, wi, _color(af), he)
            isnothing(ac) ? Dict{String, Any}() : _make(uf + 1, xa, ac, si)
        ],
        Dict(
            "width" => Omics.Plot.SI,
            "margin" => Dict("b" => 0),
            "showlegend" => false,
            "yaxis" => Dict("visible" => false),
            "xaxis" => Dict(
                "side" => "top",
                "title" => Dict("text" => "Evidence for $nt", "standoff" => 40),
                "range" => _range(-xa, xa, 0.02),
                "tickvals" => ti_,
                "ticktext" => map(
                    # TODO: Check.
                    ev ->
                        "$ev | $(round(Omics.Probability.get_probability(ev); sigdigits = 2))",
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
