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

function _trace_annotate!(tr_, an_, yc, x1, x2, x3, co, wi, si, te)

    if !isnothing(x2)

        push!(
            tr_,
            Dict(
                "y" => (yc, yc),
                "x" => (_root(x2), _root(x3)),
                "mode" => "lines",
                "line" =>
                    Dict("width" => si * 1.64, "color" => Omics.Color.hexify(co, 0.16)),
            ),
        )

    end

    ys = xs = xc = 0.0

    ya = "middle"

    xa = "center"

    sh = 0.64

    if !isnothing(x1)

        xc = _root(x1)

        push!(
            tr_,
            Dict(
                "y" => (yc, yc),
                "x" => (0.0, xc),
                "mode" => "lines",
                "line" => Dict("width" => wi, "color" => co),
            ),
        )

        push!(
            tr_,
            Dict("y" => (yc,), "x" => (xc,), "marker" => Dict("size" => si, "color" => co)),
        )

        if xc < 0.0

            xa = "right"

            xs = -si * sh

        elseif 0.0 < xc

            xa = "left"

            xs = si * sh

        else

            ya = "top"

            ys = -si * sh

        end

    end

    push!(
        an_,
        Dict(
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
            "bordercolor" => co,
            "showarrow" => false,
        ),
    )

end

function _add(pr, po, su)

    if isnothing(po)

        ev = nothing

    else

        su += ev = ge(pr, po)

    end

    ev, su

end

function _translate(pr, ev)

    ev = ev^2

    "$ev ➡ $(@sprintf "%g" get_posterior_probability(pr, ev))"

end

function plot(
    fi,
    pr,
    na_,
    p1_,
    co_ = Omics.Coloring.ID_;
    p2_ = fill(nothing, lastindex(na_)),
    p3_ = fill(nothing, lastindex(na_)),
    x1 = floor(Int, _root(ge(pr, 1e-6))),
    x2 = ceil(Int, _root(ge(pr, 0.999999))),
    la = Dict{String, Any}(),
)

    nu = lastindex(na_) + 2

    wi = 4

    si = 24

    co = "#000000"

    y1 = 0

    y2 = nu + 1

    tr_ = [
        Dict(
            "y" => (y1,),
            "x" => (0,),
            "marker" => Dict("symbol" => "diamond", "size" => si, "color" => co),
        ),
        Dict(
            "y" => (y1, y2, nothing, y2, y2),
            "x" => (0, 0, nothing, x1, x2),
            "mode" => "lines",
            "line" => Dict("width" => wi, "color" => co),
        ),
    ]

    an_ = Dict{String, Any}[]

    s1 = e1 = ge(pr)

    s2 = s3 = 0.0

    _trace_annotate!(
        tr_,
        an_,
        1,
        e1,
        nothing,
        nothing,
        co,
        wi,
        si,
        "Prior = $(Omics.Numbe.shorten(pr))",
    )

    for id in eachindex(na_)

        p1 = p1_[id]

        e1, s1 = _add(pr, p1, s1)

        e2, s2 = _add(pr, p2_[id], s2)

        e3, s3 = _add(pr, p3_[id], s3)

        _trace_annotate!(
            tr_,
            an_,
            1 + id,
            e1,
            e2,
            e3,
            co_[id],
            wi,
            si,
            "$(na_[id]) = $(isnothing(p1) ? '?' : Omics.Numbe.shorten(p1))",
        )

    end

    _trace_annotate!(
        tr_,
        an_,
        nu,
        s1,
        s2,
        s3,
        co,
        wi,
        si * 1.72,
        "Total = $(Omics.Numbe.shorten(s1))",
    )

    Omics.Plot.plot(
        fi,
        tr_,
        Omics.Dic.merg(
            Dict(
                "width" => 1280,
                "margin" => Dict("b" => 0),
                "showlegend" => false,
                "yaxis" => Dict("visible" => false),
                "xaxis" => Dict(
                    "side" => "top",
                    "range" => (x1, x2),
                    "tickvals" => x1:x2,
                    "ticktext" => map(ev -> _translate(pr, ev), x1:x2),
                    "tickangle" => -90,
                ),
                "annotations" => an_,
            ),
            la,
        ),
    )

end

end
