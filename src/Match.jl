module Match

using Distances: CorrDist

using ProgressMeter: @showprogress

using Random: shuffle!

using StatsBase: mean, quantile, sample

using ..Omics

function _order_sample(id_, sa_, ta_, ma)

    sa_[id_], ta_[id_], ma[:, id_]

end

function _order(ta_, ma)

    Omics.Clustering.order(Omics.Distance.InformationDistance(), ta_, eachcol(ma))

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

function _align!(nu_::AbstractVector{<:Integer}, ::Real) end

const _FO = 16

function _get_x(id)

    if isone(id)

        1.016

    elseif id == 2

        1.176

    elseif id == 3

        1.272

    end

end

function _annotate(yc, la, th, fe_, ft)

    an_ = Dict{String, Any}[]

    an = Dict(
        "yref" => "paper",
        "xref" => "paper",
        "yanchor" => "middle",
        "xanchor" => "left",
        "showarrow" => false,
    )

    if la

        for (id, te) in enumerate(("Sc (⧳)", "Pv", "Ad"))

            push!(
                an_,
                Omics.Dic.merg(
                    an,
                    Dict(
                        "y" => yc,
                        "x" => _get_x(id),
                        "text" => "<b>$te</b>",
                        "font" => Dict("size" => _FO),
                    ),
                ),
            )

        end

    end

    yc -= th

    for id in eachindex(fe_)

        sc, ma, pv, ad = (Omics.Strin.shorten(fl) for fl in view(ft, id, :))

        for (id, te) in enumerate(("$sc ($ma)", pv, ad))

            push!(
                an_,
                Omics.Dic.merg(
                    an,
                    Dict(
                        "y" => yc,
                        "x" => _get_x(id),
                        "text" => te,
                        "font" => Dict("size" => 10.8),
                    ),
                ),
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

    fi, fx = extrema(fs)

    ur = 2 + lastindex(fe_)

    th = inv(ur)

    ax = Dict("tickfont" => Dict("size" => _FO))

    co = Dict("y" => 0, "len" => 0.48, "thickness" => 16, "tickfont" => Dict("size" => 8.8))

    Omics.Plot.plot(
        ht,
        (
            Dict(
                "type" => "heatmap",
                "yaxis" => "y2",
                "y" => ("<b>$nt</b>",),
                "x" => sa_,
                "z" => (ta_,),
                "zmin" => Omics.Strin.shorten(ti),
                "zmax" => Omics.Strin.shorten(tx),
                "colorscale" => Omics.Palette.fractionate(Omics.Palette.pick(ta_)),
                "colorbar" => Omics.Dic.merg(
                    co,
                    Dict(
                        "x" => -0.56,
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
                "zmax" => Omics.Strin.shorten(fx),
                "colorscale" => Omics.Palette.fractionate(Omics.Palette.pick(fs)),
                "colorbar" => Omics.Dic.merg(
                    co,
                    Dict(
                        "x" => -0.4,
                        "title" => Dict("text" => "Feature"),
                        "tickvals" =>
                            map(Omics.Strin.shorten, Omics.Plot.make_tickvals(fs)),
                    ),
                ),
            ),
        ),
        Omics.Dic.merg(
            Dict(
                "margin" => Dict("r" => 220),
                "height" => max(Omics.Plot.SS, ur * 40),
                "width" => Omics.Plot.SL,
                "yaxis2" => merge(ax, Dict("domain" => (1 - th, 1))),
                "yaxis" =>
                    merge(ax, Dict("domain" => (0, 1 - th * 2), "autorange" => "reversed")),
                "xaxis" => merge(
                    ax,
                    Dict("title" => Dict("text" => Omics.Strin.coun(lastindex(sa_), ns))),
                ),
                "annotations" => _annotate(1 - th * 1.5, true, th, fe_, ft),
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

    @info "Calculating scores"

    sc_ = map(nu_ -> fu(ta_, nu_), eachrow(fs))

    id_ = findall(isnan, sc_)

    if any(id_)

        @warn "Scores have $(Omics.Strin.coun(sum(id_), "NaN"))."

    end

    ma_ = fill(NaN, uf)

    pv_ = fill(NaN, uf)

    ad_ = fill(NaN, uf)

    if 0 < um

        @info "Calculating the margin of errors using $(Omics.Strin.coun(um, "sampling"))"

        ra_ = Vector{Float64}(undef, um)

        @showprogress for id in 1:uf

            nu_ = fs[id, :]

            for id in 1:um

                ie_ = sample(1:us, round(Int, us * 0.632); replace = false)

                ra_[id] = fu(ta_[ie_], nu_[ie_])

            end

            ma_[id] = Omics.Significance.get_margin_of_error(ra_)

        end

    end

    if 0 < up

        @info "Calculating p-values using $(Omics.Strin.coun(up, "permutation"))"

        tr_ = copy(ta_)

        fr = Matrix{Float64}(undef, uf, up)

        @showprogress for ie in 1:uf

            nu_ = fs[ie, :]

            for id in 1:up

                fr[ie, id] = fu(shuffle!(tr_), nu_)

            end

        end

        ie_ = findall(<(0), sc_)

        ip_ = findall(>=(0), sc_)

        pv_[ie_], ad_[ie_], pv_[ip_], ad_[ip_] =
            Omics.Significance.get_p_value(fr, sc_, ie_, ip_)

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

function summarize_top(st, qu = 0.99)

    ab_ = abs.(view(st, :, 1))

    mean(filter!(>=(quantile(ab_, qu)), ab_))

end

function summarize_significant(st, ad = 0.1)

    ns = ab = 0

    for i1 in 1:size(st, 1)

        if st[i1, 4] < ad

            ns += 1

            ab += abs(st[i1, 1])

        end

    end

    iszero(ns) ? 0.0 : ab / ns

end

end
