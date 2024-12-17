module Match

using Distances: CorrDist

using ProgressMeter: @showprogress

using Random: shuffle!

using StatsBase: mean, quantile, sample

using ..Omics

function _order_sample(id_, sa_, ta_, fs)

    sa_[id_], ta_[id_], fs[:, id_]

end

function _order(ta_, fs)

    Omics.Clustering.order(CorrDist(), ta_, eachcol(fs))

end

function _order(ta_::AbstractVector{<:AbstractFloat}, ::AbstractMatrix)

    eachindex(ta_)

end

function _align!(nu_, st)

    if allequal(nu_)

        @warn "All numbers are $(nu_[1])."

        fill!(nu_, 0.0)

    else

        Omics.Normalization.normalize_with_0!(nu_)

        clamp!(nu_, -st, st)

    end

end

function _align!(::AbstractVector{<:Integer}, ::Real) end

function _combine(n1, n2)

    "$(Omics.Strin.shorten(n1)) ($(Omics.Strin.shorten(n2)))"

end

function _annotate(yc, th, ft)

    an_ = Vector{Dict{String, Any}}(undef, (1 + size(ft, 1)) * 2)

    for (ir, (sc, pv)) in enumerate((
        ("Score (⧱)", "P Value (𝐪)"),
        ((_combine(sc, ma), _combine(pv, ad)) for (sc, ma, pv, ad) in eachrow(ft))...,
    ))

        for ic in 1:2

            an_[(ir - 1) * 2 + ic] = Dict(
                "y" => yc,
                "x" => isone(ic) ? 1.008 : 1.188,
                "yref" => "paper",
                "xref" => "paper",
                "yanchor" => "middle",
                "xanchor" => "left",
                "text" => isone(ic) ? sc : pv,
                "font" => Dict("size" => 16),
                "showarrow" => false,
            )

        end

        yc -= th

    end

    an_

end

function _plot(ht, nt, nf, ns, fe_, sa_, ta_, fs, ft, st, la)

    sa_, ta_, fs = _order_sample(_order(ta_, fs), sa_, ta_, fs)

    _align!(ta_, st)

    foreach(nu_ -> _align!(nu_, st), eachrow(fs))

    ti, tx = extrema(ta_)

    fi, fa = extrema(fs)

    co = Dict(
        "y" => 0.5,
        "len" => 0.48,
        "thickness" => 16,
        "tickfont" => Dict("size" => 10.8),
    )

    ax = Dict("tickfont" => Dict("size" => 16))

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
                        "x" => -0.32,
                        "title" => Dict("text" => "Target"),
                        "tickvals" =>
                            map(Omics.Strin.shorten, Omics.Plot.make_tickvals(ta_)),
                    ),
                ),
            ),
            Dict(
                "type" => "heatmap",
                "y" => fe_,
                "x" => sa_,
                "z" => collect(eachrow(fs)),
                "zmin" => Omics.Strin.shorten(fi),
                "zmax" => Omics.Strin.shorten(fa),
                "colorscale" => Omics.Palette.fractionate(Omics.Palette.pick(fs)),
                "colorbar" => merge(
                    co,
                    Dict(
                        "x" => -0.24,
                        "title" => Dict("text" => "Feature"),
                        "tickvals" =>
                            map(Omics.Strin.shorten, Omics.Plot.make_tickvals(fs)),
                    ),
                ),
            ),
        ),
        Omics.Dic.merg(
            Dict(
                "height" => max(Omics.Plot.SS, ur * 40),
                "width" => Omics.Plot.SL,
                "margin" => Dict("r" => 280),
                "yaxis2" => merge(ax, Dict("domain" => (1 - th, 1))),
                "yaxis" =>
                    merge(ax, Dict("domain" => (0, 1 - th * 2), "autorange" => "reversed")),
                "xaxis" => merge(
                    ax,
                    Dict("title" => Dict("text" => Omics.Strin.coun(lastindex(sa_), ns))),
                ),
                "annotations" => _annotate(1 - th * 1.5, th, ft),
            ),
            la,
        ),
    )

end

function make(
    di,
    fu,
    ns,
    sa_,
    nt,
    ta_,
    nf,
    fe_,
    fs;
    ts = "feature_x_statistic_x_number",
    um = 10,
    up = 10,
    ue = 8,
    st = 4,
    la = Dict{String, Any}(),
)

    uf, us = size(fs)

    sa_, ta_, fs = _order_sample(sortperm(ta_), sa_, ta_, fs)

    @info "Calculating scores using $fu"

    sc_ = map(nu_ -> fu(ta_, nu_), eachrow(fs))

    un = sum(isnan, sc_)

    if 0 < un

        @warn "Scores have $(Omics.Strin.coun(un, "NaN"))."

    end

    ma_ = fill(NaN, uf)

    pv_ = fill(NaN, uf)

    ad_ = fill(NaN, uf)

    if 0 < um

        @info "Calculating the margin of errors using $(Omics.Strin.coun(um, "sampling"))"

        ra_ = Vector{Float64}(undef, um)

        ua = round(Int, us * 0.632)

        @showprogress for ie in 1:uf

            nu_ = fs[ie, :]

            for ir in 1:um

                is_ = sample(1:us, ua; replace = false)

                ra_[ir] = fu(ta_[is_], nu_[is_])

            end

            ma_[ie] = Omics.Significance.get_margin_of_error(ra_)

        end

    end

    if 0 < up

        @info "Calculating p-values using $(Omics.Strin.coun(up, "permutation"))"

        ra_ = Vector{Float64}(undef, uf * up)

        tr_ = copy(ta_)

        @showprogress for ie in 1:uf

            nu_ = fs[ie, :]

            for ir in 1:up

                ra_[(ie - 1) * up + ir] = fu(shuffle!(tr_), nu_)

            end

        end

        ie_ = findall(<(0), sc_)

        ip_ = findall(>=(0), sc_)

        pv_[ie_], ad_[ie_], pv_[ip_], ad_[ip_] =
            Omics.Significance.get_p_value(ra_, sc_, ie_, ip_)

    end

    ft = hcat(sc_, ma_, pv_, ad_)

    pr = joinpath(di, ts)

    Omics.Table.writ(
        "$pr.tsv",
        Omics.Table.make(
            nf,
            fe_,
            ["Score", "Margin of Error", "P-Value", "Adjusted P-Value"],
            ft,
        ),
    )

    if 0 < ue

        id_ = reverse!(Omics.Rank.get_extreme(sc_, ue))

        _plot("$pr.html", nt, nf, ns, fe_[id_], sa_, ta_, fs[id_, :], ft[id_, :], st, la)

    end

    ft

end

end
