module Evidence

using ..Omics

function ge(p1, p1f::Real)

    log2(Omics.Probability.get_odd(p1f) / Omics.Probability.get_odd(p1))

end

function ge(p1, p1f_)

    reduce(+, (ge(p1, p1f) for p1f in p1f_); init = log2(Omics.Probability.get_odd(p1)))

end

function get_posterior_probability(p1, ev)

    Omics.Probability.ge(Omics.Probability.get_odd(p1) * exp2(ev))

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
            "mode" => "markers+text",
            "marker" => Dict("size" => si, "color" => hm, "line" => li),
            "text" => te,
            "textfont" => Dict("size" => si * 0.8),
            "textposition" => xc < 0 ? "left" : "right",
        ),
    ]

end

function _make(::Integer, ::Integer, ::Nothing, ::Real)

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

# TODO: Plot range
function plot(ht, nt, p1, nf_, p1f_, ac = nothing; xe = 8)

    be = log2(Omics.Probability.get_odd(p1))

    ev_ = [ge(p1, p1f) for p1f in p1f_]

    af = reduce(+, ev_; init = be)

    be = _root(be)

    map!(_root, ev_, ev_)

    af = _root(af)

    ye = lastindex(nf_) + 1

    yi, ya = Omics.Plot.rang(0, ye, 0.064)

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
                "range" => Omics.Plot.rang(-xe, xe, 0.02),
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
