module Evidence

using Printf: @sprintf

using ..Omics

function ge(pr)

    log2(Omics.Probability.get_odd(pr))

end

function ge(pr, po::Real)

    log2(Omics.Probability.get_odd(po) / Omics.Probability.get_odd(pr))

end

function ge(pr, po_)

    reduce(+, (ge(pr, po) for po in po_); init = ge(pr))

end

function get_posterior_probability(pr, ev)

    Omics.Probability.ge(exp2(ev) * Omics.Probability.get_odd(pr))

end

function _root(ev)

    sign(ev) * sqrt(abs(ev))

end

function _translate(pr, ro)

    ev = ro^2

    "$ev | $(@sprintf "%g" get_posterior_probability(pr, ev))"

end

function _trace_annotate!(da_, an_, yc, ev, el, eu, he, wi, si, te)

    if !(isnothing(el) || isnothing(eu))

        push!(
            da_,
            Dict(
                "y" => (yc, yc),
                "x" => (_root(el), _root(eu)),
                "mode" => "lines",
                "line" =>
                    Dict("width" => si * 1.64, "color" => Omics.Color.hexify(he, 0.4)),
            ),
        )

    end

    xc = 0

    ya = "middle"

    xa = "center"

    ys = 0

    xs = 0

    if !isnothing(ev)

        xc = _root(ev)

        push!(
            da_,
            Dict(
                "y" => (yc, yc),
                "x" => (0, xc),
                "mode" => "lines",
                "line" => Dict("width" => wi, "color" => he),
            ),
        )

        push!(
            da_,
            Dict("y" => (yc,), "x" => (xc,), "marker" => Dict("size" => si, "color" => he)),
        )

        if xc < 0

            xa = "right"

            xs = si * -0.64

        elseif 0 < xc

            xa = "left"

            xs = si * 0.64

        else

            ya = "top"

            ys = si * -0.56

        end

    end

    push!(
        an_,
        Dict(
            "showarrow" => false,
            "y" => yc,
            "x" => xc,
            "yanchor" => ya,
            "xanchor" => xa,
            "yshift" => ys,
            "xshift" => xs,
            "text" => te,
            "font" => Dict("size" => si * 0.64),
            "bgcolor" => "#ffffff",
            "borderpad" => 4,
            "borderwidth" => 2,
            "bordercolor" => he,
        ),
    )

end

function plot(
    ht,
    nt,
    pr,
    nf_,
    po_,
    he_ = Omics.Palette.HE_;
    pl_ = fill(nothing, lastindex(nf_)),
    pu_ = fill(nothing, lastindex(nf_)),
    xi = floor(_root(ge(pr, 1e-6))),
    xa = ceil(_root(ge(pr, 0.999999))),
    la = Dict{String, Any}(),
)

    ur = 1 + lastindex(nf_) + 1

    wi = 4

    si = 24

    he = "#000000"

    yi, ya = Omics.Plot.rang(1, ur, 0.08)

    li = "line" => Dict("width" => wi, "color" => he)

    da_ = [
        Dict(
            "y" => (yi,),
            "x" => (0,),
            "marker" => Dict("symbol" => "diamond", "size" => si, "color" => he),
        ),
        Dict("y" => (yi, ya), "x" => (0, 0), "mode" => "lines", li),
        Dict("y" => (ya, ya), "x" => (xi, xa), "mode" => "lines", li),
    ]

    an_ = Dict{String, Any}[]

    ev = ge(pr)

    to = ev

    tl = tu = 0

    _trace_annotate!(da_, an_, 1, ev, nothing, nothing, he, wi, si, "Prior = $pr")

    for id in eachindex(nf_)

        po = po_[id]

        if isnothing(po)

            ev = nothing

        else

            ev = ge(pr, po)

            to += ev

        end

        pl = pl_[id]

        if isnothing(pl)

            el = nothing

        else

            el = ge(pr, pl)

            tl += el

        end

        pu = pu_[id]

        if isnothing(pu)

            eu = nothing

        else

            eu = ge(pr, pu)

            tu += eu

        end

        _trace_annotate!(da_, an_, 1 + id, ev, el, eu, he_[id], wi, si, nf_[id])

    end

    _trace_annotate!(da_, an_, ur, to, tl, tu, he, wi, si * 1.56, "Total")

    Omics.Plot.plot(
        ht,
        da_,
        Omics.Dic.merg(
            Dict(
                "width" => Omics.Plot.SI,
                "margin" => Dict("b" => 0),
                "showlegend" => false,
                "yaxis" => Dict("visible" => false),
                "xaxis" => Dict(
                    "side" => "top",
                    "title" => Dict(
                        "text" => "Evidence for $nt",
                        "font" => Dict("size" => 32),
                        "standoff" => 32,
                    ),
                    "range" => (xi, xa),
                    "tickvals" => xi:xa,
                    "ticktext" => map(ti -> _translate(pr, ti), xi:xa),
                    "tickangle" => -90,
                ),
                "annotations" => an_,
            ),
            la,
        ),
    )

end

end
