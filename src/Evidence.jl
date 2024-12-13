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

    reduce(+, (ge(pr, po) for po in po_); init = log2(Omics.Probability.get_odd(pr)))

end

function get_posterior_probability(pr, ev)

    Omics.Probability.ge(Omics.Probability.get_odd(pr) * exp2(ev))

end

function _root(ev)

    sign(ev) * sqrt(abs(ev))

end

function _translate(pr, ro)

    "$ro | $(@sprintf "%g" get_posterior_probability(pr, ro^2))"

end

function _trace_annotate(da_, an_, yc, xc, xl, xu, he, wi, si, te)

    if !(iszero(xl) || iszero(xu))

        push!(
            da_,
            Dict(
                "y" => (yc, yc),
                "x" => (xl, xu),
                "mode" => "lines",
                "line" => Dict("width" => wi * 2, "color" => Omics.Color.hexify(he, 0.2)),
            ),
        )

    end

    xa, xs = if iszero(xc)

        "center", 0

    else

        push!(
            da_,
            Dict(
                "legendgroup" => yc,
                "y" => (yc, yc),
                "x" => (0, xc),
                "mode" => "lines",
                "line" => Dict("width" => wi, "color" => he),
            ),
        )

        push!(
            da_,
            Dict(
                "legendgroup" => yc,
                "y" => (yc,),
                "x" => (xc,),
                "marker" => Dict("size" => si, "color" => he),
            ),
        )

        xc < 0 ? ("right", -1) : ("left", 1)

    end

    push!(
        an_,
        Dict(
            "showarrow" => false,
            "y" => yc,
            "x" => xc,
            "yanchor" => "top",
            "xanchor" => xa,
            "yshift" => - wi *2,
            "xshift" => xs * si,
            "text" => te,
            "font" => Dict("size" => si * 0.56),
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
    ac = nothing;
    xi = _root(ge(pr, 1e-6)),
    xa = _root(ge(pr, 0.999999)),
    lo_ = zeros(lastindex(nf_)),
    up_ = zeros(lastindex(nf_)),
    he_ = Omics.Palette.HE_,
)

    ur = lastindex(nf_) + 2

    wi = 4

    si = 24

    he = "#000000"

    yi, ya = Omics.Plot.rang(1, ur, 0.08)

    li = "line" => Dict("width" => wi, "color" => he)

    da_ = [
        Dict(
            "y" => (yi,),
            "x" => (0,),
            "marker" => Dict("symbol" => "triangle-up", "size" => si, "color" => he),
        ),
        Dict("y" => (yi, ya), "x" => (0, 0), "mode" => "lines", li),
        Dict("y" => (ya, ya), "x" => (xi, xa), "mode" => "lines", li),
    ]

    an_ = Dict{String, Any}[]

    if !isnothing(ac)

        push!(
            da_,
            Dict(
                "y" => (ya,),
                "x" => (ac ? xa : xi,),
                "marker" => Dict("symbol" => "diamond", "size" => si, "color" => he),
                "cliponaxis" => false,
            ),
        )

    end

    ev = ge(pr)

    to = ev

    tl = tu = 0

    _trace_annotate(da_, an_, 1, _root(ev), tl, tu, he, wi, si, "Prior = $pr")

    for id in eachindex(nf_)

        po = po_[id]

        ev = iszero(po) ? 0 : ge(pr, po)

        lo = ge(pr, lo_[id])

        up = ge(pr, up_[id])

        to += ev

        tl += lo

        tu += up

        _trace_annotate(
            da_,
            an_,
            1 + id,
            _root(ev),
            _root(lo),
            _root(up),
            he_[id],
            wi,
            si,
            nf_[id],
        )

    end

    _trace_annotate(da_, an_, ur, _root(to), _root(tl), _root(tu), he, wi, si * 2, "Total")

    ti_ = floor(xi):ceil(xa)

    Omics.Plot.plot(
        ht,
        da_,
        Dict(
            "width" => Omics.Plot.SI,
            "margin" => Dict("b" => 0),
            "showlegend" => false,
            "yaxis" => Dict("visible" => false),
            "xaxis" => Dict(
                "side" => "top",
                "title" => Dict("text" => "Evidence for $nt", "standoff" => 40),
                "range" => (xi, xa),
                "tickvals" => ti_,
                "ticktext" => map(ti -> _translate(pr, ti), ti_),
                "tickangle" => -90,
                "ticks" => "inside",
                "ticklen" => 16,
                "tickwidth" => 2,
                "tickcolor" => Omics.Color.LI,
            ),
            "annotations" => an_,
        ),
    )

end

end
