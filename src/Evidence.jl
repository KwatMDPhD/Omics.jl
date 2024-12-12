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

function _translate(pr, ev)
    
    "$ev | $(@sprintf("%g", get_posterior_probability(pr, ev^2)))"

end

function _trace(yc, xc, wi, si, he)

    [
        Dict(
            "legendgroup" => yc,
            "y" => (yc, yc),
            "x" => (0, xc),
            "mode" => "lines",
            "line" => Dict("width" => wi, "color" => he),
        ),
        Dict(
            "legendgroup" => yc,
            "y" => (yc,),
            "x" => (xc,),
            "marker" => Dict("size" => si, "color" => he),
        ),
    ]

end

function _annotate(yc, xc, te, si, he)

    if iszero(xc)

        xa = "center"

        xs = 0


    elseif xc < 0

        xa = "right"

        xs = -1

    else

        xa = "left"

        xs = 1

    end

    Dict(
        "showarrow" => false,
        "y" => yc,
        "x" => xc,
        "xanchor" => xa,
        "xshift" => xs * si * 1.6,
        "text" => te,
        "font" => Dict("family" => "Monospace", "size" => si),
        "bgcolor" => "#ffffff",
        "borderpad" => 4,
        "borderwidth" => 2,
        "bordercolor" => he,
    )

end

function plot(
    ht,
    nt,
    pr,
    nf_,
    po_,
    he_ = Omics.Palette.color(eachindex(nf_));
    xi = _root(ge(pr, 1e-6)),
    xa = _root(ge(pr, 0.999999)),
    lo_ = fill(xi, lastindex(nf_)),
    up_ = fill(xa, lastindex(nf_)),
    ac = nothing,
)

    ur = lastindex(nf_) + 2

    wi = 4

    he = "#000000"

    yi, ya = Omics.Plot.rang(1, ur, 0.08)

    da_ = [
        Dict(
            "y" => (yi,),
            "x" => (0,),
            "marker" => Dict("symbol" => "triangle-up", "size" => 24, "color" => he),
        ),
        Dict(
            "y" => (yi, ya),
            "x" => (0, 0),
            "mode" => "lines",
            "line" => Dict("width" => wi, "color" => he),
        ),
        Dict(
            "y" => (ya, ya),
            "x" => (xi, xa),
            "mode" => "lines",
            "line" => Dict("width" => wi, "color" => he),
        ),
    ]

    an_ = Dict{String, Any}[]

    si = 24

    st = 16

    if !isnothing(ac)

        push!(
            da_,
            Dict(
                "y" => (ya,),
                "x" => (ac ? xa : xi,),
                "marker" => Dict("symbol" => "diamond", "size" => si * 0.8, "color" => he),
                "cliponaxis" => false,
            ),
        )

    end

    ev = ge(pr)

    to = ev

    lo = up = 0.0

    yc = 1

    xc = _root(ev)

    append!(da_, _trace(yc, xc, wi, si, he))

    push!(an_, _annotate(yc, xc, "Prior", st, he))

    for id in eachindex(nf_)

        yc = 1 + id

        nf = nf_[id]

        hx = he_[id]

        lw = lo_[id]

        ue = up_[id]

        lo += lw

        up += ue

        push!(
            da_,
            Dict(
                "y" => (yc, yc),
                "x" => (lw, ue),
                "mode" => "lines",
                "line" => Dict("width" => wi, "color" => Omics.Color.hexify(hx, 0.2)),
            ),
        )

        po = po_[id]

        if isnan(po)

            xc = 0

        else

            ev = ge(pr, po)

            to += ev

            xc = _root(ev)

            append!(da_, _trace(yc, xc, wi, si, hx))

        end

        push!(an_, _annotate(yc, xc, nf, st, hx))

    end

    xc = _root(to)

    push!(
        da_,
        Dict(
            "y" => (ur, ur),
            "x" => (lo, up),
            "mode" => "lines",
            "line" => Dict("width" => wi, "color" => Omics.Color.hexify(he, 0.2)),
        ),
    )

    append!(da_, _trace(ur, xc, wi, si * 2, he))

    push!(an_, _annotate(ur, xc, "Total", st * 1.6, he))

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
