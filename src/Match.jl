module Match

using Distances: CorrDist

using Random: shuffle!

using StatsBase: sample

using ..Omics

function _sort(id_, sa_, ta_, nu)

    sa_[id_], ta_[id_], nu[:, id_]

end

function _order(ta_, nu)

    Omics.Clustering.order(CorrDist(), ta_, eachcol(nu))

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

function _index(i1, u2, i2)

    (i1 - 1) * u2 + i2

end

function _print(n1, n2)

    "$(Omics.Strin.shorten(n1)) ($(Omics.Strin.shorten(n2)))"

end

function _annotate(yc, th, re)

    uc = 2

    an_ = Vector{Dict{String, Any}}(undef, (1 + size(re, 1)) * uc)

    te___ = vcat(
        ("Score (⧱)", "P Value (𝐪)"),
        [(_print(sc, ma), _print(pv, qv)) for (sc, ma, pv, qv) in eachrow(re)],
    )

    for ir in eachindex(te___)

        te_ = te___[ir]

        for ic in 1:uc

            an_[_index(ir, uc, ic)] = Dict(
                "yref" => "paper",
                "xref" => "paper",
                "y" => yc,
                "x" => isone(ic) ? 1.016 : 1.128,
                "yanchor" => "middle",
                "xanchor" => "left",
                "text" => te_[ic],
                "showarrow" => false,
            )

        end

        yc -= th

    end

    an_

end

function _plot(ht, ns, sa_, nt, ta_, nf, fe_, nu, re, st, la)

    sa_, ta_, nu = _sort(_order(ta_, nu), sa_, ta_, nu)

    _normalize!(ta_, st)

    foreach(nu_ -> _normalize!(nu_, st), eachrow(nu))

    ti, tx = extrema(ta_)

    fi, fa = extrema(nu)

    co = Dict(
        "x" => 0.5,
        "orientation" => "h",
        "len" => 0.56,
        "thickness" => 16,
        "outlinewidth" => 0,
        "title" => Dict("side" => "top"),
    )

    ur = 2 + lastindex(fe_)

    th = inv(ur)

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
                        "y" => -0.48,
                        "tickvals" =>
                            map(Omics.Strin.shorten, Omics.Plot.make_tickvals(ta_)),
                    ),
                ),
            ),
            Dict(
                "type" => "heatmap",
                "y" => fe_,
                "x" => sa_,
                "z" => collect(eachrow(nu)),
                "zmin" => Omics.Strin.shorten(fi),
                "zmax" => Omics.Strin.shorten(fa),
                "colorscale" => Omics.Palette.fractionate(Omics.Palette.pick(nu)),
                "colorbar" => merge(
                    co,
                    Dict(
                        "y" => -0.64,
                        "tickvals" =>
                            map(Omics.Strin.shorten, Omics.Plot.make_tickvals(nu)),
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
                "yaxis2" => Dict("domain" => (1 - th, 1)),
                "yaxis" => Dict("domain" => (0, 1 - th * 2), "autorange" => "reversed"),
                "xaxis" => Dict("title" => Dict("text" => "$ns ($(lastindex(sa_)))")),
                "annotations" => _annotate(1 - th * 1.5, th, re),
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
    nu;
    ts = "feature_x_statistic_x_number",
    um = 10,
    uv = 10,
    ue = 8,
    st = 3,
    la = Dict{String, Any}(),
)

    uf, us = size(nu)

    sa_, ta_, nu = _sort(sortperm(ta_), sa_, ta_, nu)

    sc_ = map(nu_ -> fu(ta_, nu_), eachrow(nu))

    ma_ = fill(NaN, uf)

    pv_ = fill(NaN, uf)

    qv_ = fill(NaN, uf)

    if 0 < um

        ra_ = Vector{Float64}(undef, um)

        ua = round(Int, us * 0.632)

        for id in 1:uf

            nu_ = nu[id, :]

            for ir in 1:um

                is_ = sample(1:us, ua; replace = false)

                ra_[ir] = fu(ta_[is_], nu_[is_])

            end

            ma_[id] = Omics.Significance.get_margin_of_error(ra_)

        end

    end

    if 0 < uv

        ra_ = Vector{Float64}(undef, uf * uv)

        co = copy(ta_)

        for id in 1:uf

            nu_ = nu[id, :]

            for ir in 1:uv

                ra_[_index(id, uv, ir)] = fu(shuffle!(co), nu_)

            end

        end

        ie_ = findall(<(0), sc_)

        ip_ = findall(>=(0), sc_)

        pv_[ie_], qv_[ie_], pv_[ip_], qv_[ip_] =
            Omics.Significance.get_p_value(ra_, sc_, ie_, ip_)

    end

    re = hcat(sc_, ma_, pv_, qv_)

    pr = joinpath(di, ts)

    Omics.Table.writ(
        "$pr.tsv",
        Omics.Table.make(nf, fe_, ["Score", "Margin of Error", "P-Value", "Q-Value"], re),
    )

    if 0 < ue

        id_ = reverse!(Omics.Rank.get_extreme(sc_, ue))

        _plot("$pr.html", ns, sa_, nt, ta_, nf, fe_[id_], nu[id_, :], re[id_, :], st, la)

    end

    re

end

end
