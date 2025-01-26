module Match

using Distances: CorrDist, Euclidean

using Random: shuffle!

using StatsBase: sample

using ..Omics

# TODO: Publicize
function _linearize(i1, u2, i2)

    (i1 - 1) * u2 + i2

end

function _sort(id_, sa_, ta_, da)

    sa_[id_], ta_[id_], da[:, id_]

end

function _order(ta_, da)

    Omics.Clustering.order(isone(size(da, 1)) ? Euclidean() : CorrDist(), ta_, eachcol(da))

end

function _order(ta_::AbstractVector{<:AbstractFloat}, ::Any)

    eachindex(ta_)

end

function _normalize!(nu_, st)

    if allequal(nu_)

        @warn "All numbers are $(nu_[1])."

        fill!(nu_, 0.0)

    else

        Omics.Normalization.normalize_with_0!(nu_)

        clamp!(nu_, -st, st)

    end

end

function _normalize!(::AbstractVector{<:Integer}, ::Any) end

function _print(n1, n2)

    "$(Omics.Strin.shorten(n1)) ($(Omics.Strin.shorten(n2)))"

end

function _annotate(yc, wi, nf, he, re)

    an = Dict(
        "yref" => "paper",
        "xref" => "paper",
        "yanchor" => "middle",
        "showarrow" => false,
    )

    yh = yc + wi * 0.32

    an_ = [
        merge(
            an,
            Dict(
                "y" => yh,
                "x" => 0.5,
                "text" => nf,
                "font" => Dict("size" => Omics.Plot.S2),
            ),
        ),
    ]

    if he

        push!(
            an_,
            merge(
                an,
                Dict("y" => yh, "x" => 1.016, "xanchor" => "left", "text" => "Score (⧱)"),
            ),
        )

        push!(
            an_,
            merge(
                an,
                Dict("y" => yh, "x" => 1.128, "xanchor" => "left", "text" => "P Value (𝐪)"),
            ),
        )

    end

    yc -= wi * 0.5

    for (sc, ma, pv, qv) in eachrow(re)

        push!(
            an_,
            merge(
                an,
                Dict(
                    "y" => yc,
                    "x" => 1.016,
                    "xanchor" => "left",
                    "text" => _print(sc, ma),
                ),
            ),
        )

        push!(
            an_,
            merge(
                an,
                Dict(
                    "y" => yc,
                    "x" => 1.128,
                    "xanchor" => "left",
                    "text" => _print(pv, qv),
                ),
            ),
        )

        yc -= wi

    end

    an_

end

function _plot(ht, ns, sa_, nt, ta_, nf, fe_, da, re, st, la)

    sa_, ta_, da = _sort(_order(ta_, da), sa_, ta_, da)

    _normalize!(ta_, st)

    foreach(nu_ -> _normalize!(nu_, st), eachrow(da))

    ti, tx = extrema(ta_)

    ni, na = extrema(da)

    co = Dict(
        "orientation" => "h",
        "x" => 0.5,
        "len" => 0.56,
        "thickness" => 16,
        "outlinewidth" => 0,
        "title" => Dict("side" => "top"),
    )

    ur = 2 + lastindex(fe_)

    wi = inv(ur)

    if eltype(ta_) == Bool

        ta_ = convert(Vector{Int}, ta_)

    end

    Omics.Plot.plot(
        ht,
        (
            Dict(
                "type" => "heatmap",
                "yaxis" => "y2",
                "y" => (nt,),
                "x" => sa_,
                "z" => (ta_,),
                "zmin" => Omics.Strin.shorten(ti),
                "zmax" => Omics.Strin.shorten(tx),
                "colorscale" => Omics.Palette.fractionate(Omics.Palette.pick(ta_)),
                "colorbar" => merge(
                    co,
                    Dict(
                        "y" => -0.344,
                        "tickvals" => map(Omics.Strin.shorten, Omics.Plot.tick(ta_)),
                    ),
                ),
            ),
            Dict(
                "type" => "heatmap",
                "y" => map(fe -> Omics.Strin.limit(fe, 40), fe_),
                "x" => sa_,
                "z" => collect(eachrow(da)),
                "zmin" => Omics.Strin.shorten(ni),
                "zmax" => Omics.Strin.shorten(na),
                "colorscale" => Omics.Palette.fractionate(Omics.Palette.pick(da)),
                "colorbar" => merge(
                    co,
                    Dict(
                        "y" => -0.432,
                        "tickvals" => map(Omics.Strin.shorten, Omics.Plot.tick(da)),
                    ),
                ),
            ),
        ),
        Omics.Dic.merg(
            Dict(
                "height" => max(Omics.Plot.SS, ur * 40),
                "width" => Omics.Plot.SL,
                "margin" => Dict("r" => 232),
                "title" => Dict("xref" => "paper", "text" => nf),
                "yaxis2" => Dict("domain" => (1.0 - wi, 1.0)),
                "yaxis" =>
                    Dict("domain" => (0.0, 1.0 - wi * 2.0), "autorange" => "reversed"),
                "xaxis" => Dict("title" => Dict("text" => "$ns ($(lastindex(sa_)))")),
                "annotations" => _annotate(1.0 - wi * 1.5, wi, re),
            ),
            la,
        ),
    )

end

function go(
    di,
    fu,
    ns,
    sa_,
    nt,
    ta_,
    nf,
    fe_,
    da;
    um = 10,
    uv = 10,
    ue = 8,
    st = 3.0,
    la = Dict{String, Any}(),
)

    uf, us = size(da)

    sa_, ta_, da = _sort(sortperm(ta_), sa_, ta_, da)

    sc_ = map(nu_ -> fu(ta_, nu_), eachrow(da))

    ma_ = fill(NaN, uf)

    pv_ = fill(NaN, uf)

    qv_ = fill(NaN, uf)

    if 0 < um

        # TODO: Subsample from each group.

        ra_ = Vector{Float64}(undef, um)

        ua = round(Int, us * 0.632)

        for ie in 1:uf

            nu_ = da[ie, :]

            for ir in 1:um

                is_ = sample(1:us, ua; replace = false)

                ra_[ir] = fu(ta_[is_], nu_[is_])

            end

            ma_[ie] = Omics.Significance.get_margin_of_error(ra_)

        end

    end

    if 0 < uv

        ra_ = Vector{Float64}(undef, uf * uv)

        co = copy(ta_)

        for ie in 1:uf

            nu_ = da[ie, :]

            for ir in 1:uv

                ra_[_linearize(ie, uv, ir)] = fu(shuffle!(co), nu_)

            end

        end

        pn_, qn_, pp_, qp_ = Omics.Significance.ge(ra_, sc_)

        pv_ = vcat(pn_, pp_)

        qv_ = vcat(qn_, qp_)

    end

    re = hcat(sc_, ma_, pv_, qv_)

    pr = joinpath(di, "result")

    Omics.Table.writ(
        "$pr.tsv",
        Omics.Table.make(
            nf,
            fe_,
            ["Score", "95% Margin of Error", "P-Value", "Q-Value"],
            re,
        ),
    )

    if 0 < ue

        io_ = findall(!isnan, sc_)

        ix_ = io_[reverse!(Omics.Extreme.ge(sc_[io_], ue))]

        _plot("$pr.html", ns, sa_, nt, ta_, nf, fe_[ix_], da[ix_, :], re[ix_, :], st, la)

    end

    re

end

function summarize(ht, ns, sa_, nt, vt_, na___, nh___; st = 3.0, la = Dict{String, Any}())

    io_ = sortperm(vt_)

    vt_ = vt_[io_]

    _normalize!(vt_, st)

    ti, tx = extrema(vt_)

    co = Dict(
        "orientation" => "h",
        "x" => 0.5,
        "len" => 0.56,
        "thickness" => 16,
        "outlinewidth" => 0,
        "title" => Dict("side" => "top"),
    )

    if eltype(vt_) == Bool

        vt_ = convert(Vector{Int}, vt_)

    end

    tr_ = [
        Dict(
            "type" => "heatmap",
            "y" => (nt,),
            "x" => sa_,
            "z" => (vt_,),
            "zmin" => Omics.Strin.shorten(ti),
            "zmax" => Omics.Strin.shorten(tx),
            "colorscale" => Omics.Palette.fractionate(Omics.Palette.pick(vt_)),
            "colorbar" => merge(
                co,
                Dict(
                    "y" => -0.344,
                    "tickvals" => map(Omics.Strin.shorten, Omics.Plot.tick(vt_)),
                ),
            ),
        ),
    ]

    ur = 1 + lastindex(nh___) + sum(nh_ -> lastindex(nh_[2]), nh___)

    wi = inv(ur)

    ba = 1.0 - wi

    la = Omics.Dic.merg(
        Dict(
            "height" => max(Omics.Plot.SS, ur * 40),
            "width" => Omics.Plot.SL,
            "margin" => Dict("r" => 232),
            "yaxis" => Dict("domain" => (ba, 1.0)),
            "xaxis" => Dict(
                "side" => "top",
                "title" => Dict("text" => "$ns ($(lastindex(sa_)))"),
            ),
        ),
        la,
    )

    an_ = Dict{String, Any}[]

    for ih in eachindex(nh___)

        nf, fe_ = nh___[ih]

        na_ = filter(na_ -> na_[1] == nf, na___)[]

        ie_ = indexin(fe_, na_[2])

        vf = na_[3][ie_, io_]

        vr = na_[4][ie_, :]

        foreach(nu_ -> _normalize!(nu_, st), eachrow(vf))

        ni, na = extrema(vf)

        it = ih + 1

        push!(
            tr_,
            Dict(
                "yaxis" => "y$it",
                "type" => "heatmap",
                "y" => map(fe -> Omics.Strin.limit(fe, 40), fe_),
                "x" => sa_,
                "z" => collect(eachrow(vf)),
                "zmin" => Omics.Strin.shorten(ni),
                "zmax" => Omics.Strin.shorten(na),
                "colorscale" => Omics.Palette.fractionate(Omics.Palette.pick(vf)),
                isone(ih) ?
                "colorbar" => merge(
                    co,
                    Dict(
                        "y" => -0.432,
                        "tickvals" => map(Omics.Strin.shorten, Omics.Plot.tick(vf)),
                    ),
                ) : "showscale" => false,
            ),
        )

        th = ba - wi

        bh = th - wi * lastindex(fe_)

        la["yaxis$it"] = Dict("domain" => (bh, th), "autorange" => "reversed")

        append!(an_, _annotate(th, wi, nf, isone(ih), vr))

        ba = bh

    end

    la["annotations"] = an_

    Omics.Plot.plot(ht, tr_, la, Dict("editable" => true))

end

end
