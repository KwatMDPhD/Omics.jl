module Match

using Distances: CorrDist

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

    Omics.Clustering.order(CorrDist(), ta_, eachcol(da))

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

function _annotate(yc, wi, re)

    uc = 2

    an_ = Vector{Dict{String, Any}}(undef, (1 + size(re, 1)) * uc)

    te___ = vcat(
        ("Score (⧱)", "P Value (𝐪)"),
        [(_print(sc, ma), _print(pv, qv)) for (sc, ma, pv, qv) in eachrow(re)],
    )

    for ir in eachindex(te___)

        te_ = te___[ir]

        for ic in 1:uc

            an_[_linearize(ir, uc, ic)] = Dict(
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
                        "tickvals" => map(Omics.Strin.shorten, Omics.Plot.tick(ta_)),
                    ),
                ),
            ),
            Dict(
                "type" => "heatmap",
                "y" => fe_,
                "x" => sa_,
                "z" => collect(eachrow(da)),
                "zmin" => Omics.Strin.shorten(ni),
                "zmax" => Omics.Strin.shorten(na),
                "colorscale" => Omics.Palette.fractionate(Omics.Palette.pick(da)),
                "colorbar" => merge(
                    co,
                    Dict(
                        "y" => -0.64,
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
    ts = "feature_x_result_x_number",
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

        il_ = findall(<(0.0), sc_)

        ig_ = findall(>=(0.0), sc_)

        pv_[il_], qv_[il_], pv_[ig_], qv_[ig_] = Omics.Significance.get(ra_, sc_, il_, ig_)

    end

    re = hcat(sc_, ma_, pv_, qv_)

    pr = joinpath(di, ts)

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

        ix_ = reverse!(Omics.Extreme.get(sc_, ue))

        _plot("$pr.html", ns, sa_, nt, ta_, nf, fe_[ix_], da[ix_, :], re[ix_, :], st, la)

    end

    re

end

end
