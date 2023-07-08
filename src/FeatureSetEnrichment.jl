module FeatureSetEnrichment

using ProgressMeter: @showprogress

using StatsBase: sample

using ..BioLab

function _get_absolute_raise(sc_, id, ex)

    ab = abs(sc_[id])

    if !isone(ex)

        ab ^= ex

    end

    ab

end

function _sum_10(sc_, ex, bo_)

    n = length(sc_)

    su1 = 0.0

    su0 = 0.0

    for id in 1:n

        if bo_[id]

            su1 += _get_absolute_raise(sc_, id, ex)

        else

            su0 += 1.0

        end

    end

    n, su1, su0

end

function _sum_all1(sc_, ex, bo_)

    n = length(sc_)

    su = 0.0

    su1 = 0.0

    for id in 1:n

        ab = _get_absolute_raise(sc_, id, ex)

        su += ab

        if bo_[id]

            su1 += ab

        end

    end

    n, su, su1

end

function _make_annotation(di_...)

    BioLab.Plot.make_annotation(
        Dict("bgcolor" => "#fcfcfc", "borderpad" => 4, "borderwidth" => 2),
        di_...,
    )

end

function _plot_mountain(
    ht,
    sc_,
    fe_,
    bo_,
    mo_,
    en;
    title_text = "Set Enrichment",
    naf = "Feature",
    nas = "Score",
    nal = "Low",
    nah = "High",
)

    n = length(fe_)

    x = collect(1:n)

    scatter = Dict("x" => x, "text" => fe_, "mode" => "lines", "fill" => "tozeroy")

    coe1 = "#07fa07"

    coe2 = "rgba(7, 250, 7, 0.32)"

    yaxis1_domain = (0, 0.24)

    yaxis2_domain = (0.25, 0.31)

    yaxis3_domain = (0.32, 1)

    #xaxis_range_margin = n * 0.01

    annotation_margin = 0.016

    annotation_font_size = 16

    BioLab.Plot.plot(
        ht,
        [
            BioLab.Dict.merge(
                scatter,
                Dict(
                    "y" => sc_,
                    "line" => Dict("width" => 1.6, "color" => "#351e1c"),
                    "fillcolor" => "#c0c0c0",
                ),
            ),
            Dict(
                "yaxis" => "y2",
                "y" => fill(0, sum(bo_)),
                "x" => x[bo_],
                "text" => fe_[bo_],
                "mode" => "markers",
                "marker" => Dict(
                    "symbol" => "line-ns",
                    "size" => 24,
                    "line" => Dict(
                        "width" => 1.08,
                        "color" => BioLab.Plot.color(sc_[bo_], BioLab.Plot.COBWR),
                    ),
                ),
                "hoverinfo" => "x+text",
            ),
            BioLab.Dict.merge(
                scatter,
                Dict(
                    "yaxis" => "y3",
                    "y" => mo_,
                    "line" => Dict("width" => 3.2, "color" => coe1),
                    "fillcolor" => coe2,
                ),
            ),
        ],
        Dict(
            "showlegend" => false,
            "title" => Dict(
                "text" => "<b>$(BioLab.String.limit(title_text, 32))</b>",
                "font" => Dict("size" => 32, "family" => "Relaway", "color" => "#2b2028"),
            ),
            "yaxis" => BioLab.Plot.make_axis(
                Dict("domain" => yaxis1_domain, "title" => Dict("text" => "<b>$nas</b>")),
            ),
            "yaxis2" => BioLab.Plot.make_axis(
                Dict(
                    "domain" => yaxis2_domain,
                    "title" => Dict("text" => "<b>Set</b>"),
                    "tickvals" => (),
                ),
            ),
            "yaxis3" => BioLab.Plot.make_axis(
                Dict("domain" => yaxis3_domain, "title" => Dict("text" => "<b>Enrichment</b>")),
            ),
            "xaxis" => BioLab.Plot.make_axis(
                BioLab.Plot.make_spike(),
                Dict(
                    #"range" => (1 - xaxis_range_margin, n + xaxis_range_margin),
                    "title" => Dict("text" => "<b>$naf (n=$n)</b>"),
                ),
            ),
            "annotations" => (
                _make_annotation(
                    Dict(
                        "y" => 1,
                        "x" => 0.5,
                        "text" => "Enrichment = <b>$(BioLab.String.format(en))</b>",
                        "font" => Dict("size" => 20, "color" => "#224634"),
                        "borderpad" => 8,
                        "bordercolor" => coe1,
                    ),
                ),
                _make_annotation(
                    Dict(
                        "y" => yaxis1_domain[2] * 1 / 4,
                        "x" => annotation_margin,
                        "text" => nah,
                        "font" => Dict("size" => annotation_font_size, "color" => "#ff1992"),
                        "bordercolor" => "#fcc9b9",
                    ),
                ),
                _make_annotation(
                    Dict(
                        "y" => yaxis1_domain[2] * 3 / 4,
                        "x" => 1 - annotation_margin,
                        "text" => nal,
                        "font" => Dict("size" => annotation_font_size, "color" => "#1993ff"),
                        "bordercolor" => "#b9c9fc",
                    ),
                ),
            ),
        ),
    )

end

struct KS end

struct KSa end

struct KLi end

struct KLioP end

struct KLioM end

function make_string(al)

    BioLab.String.split_get(string(al), '.', 3)[1:(end - 2)]

end

function _enrich(al::KS, sc_, ex, bo_, mo_)

    n, su1, su0 = _sum_10(sc_, ex, bo_)

    cu = 0.0

    de = 1 / su0

    mo = !isnothing(mo_)

    eta = 0.0

    et = 0.0

    for id in 1:n

        if bo_[id]

            cu += _get_absolute_raise(sc_, id, ex) / su1

        else

            cu -= de

        end

        if mo

            mo_[id] = cu

        end

        cua = abs(cu)

        if eta < cua

            eta = cua

            et = cu

        end

    end

    et

end

function _enrich(al::KSa, sc_, ex, bo_, mo_)

    n, su1, su0 = _sum_10(sc_, ex, bo_)

    cu = 0.0

    de = 1.0 / su0

    mo = !isnothing(mo_)

    ar = 0.0

    for id in 1:n

        if bo_[id]

            cu += _get_absolute_raise(sc_, id, ex) / su1

        else

            cu -= de

        end

        if mo

            mo_[id] = cu

        end

        ar += cu

    end

    ar / n

end

function _get_left(le, pr, mi)

    le -= pr

    if le < mi

        le = mi

    end

    le

end

function _enrich(al::KLi, sc_, ex, bo_, mo_)

    n, su, su1 = _sum_all1(sc_, ex, bo_)

    ep = eps()

    ri = ep

    ri1 = ep

    le = su

    le1 = su1

    pra = 0.0

    prb = false

    mo = !isnothing(mo_)

    ar = 0.0

    for id in 1:n

        ab = _get_absolute_raise(sc_, id, ex)

        ri += ab

        bo = bo_[id]

        if bo

            ri1 += ab

        end

        rin = ri / su

        ri1n = ri1 / su1

        le = _get_left(le, pra, ep)

        if prb

            le1 = _get_left(le1, pra, ep)

        end

        len = le / su

        le1n = le1 / su1

        en = BioLab.Information.get_antisymmetric_kullback_leibler_divergence(ri1n, rin, le1n, len)

        pra = ab

        prb = bo

        if mo

            mo_[id] = en

        end

        ar += en

    end

    ar / n

end

function _enrich_klio(fu, sc_, ex, bo_, mo_)

    n, su, su1 = _sum_all1(sc_, ex, bo_)

    su0 = su - su1

    ep = eps()

    ri = ep

    ri1 = ep

    ri0 = ep

    le = su

    le1 = su1

    le0 = su0

    pra = 0.0

    prb = false

    mo = !isnothing(mo_)

    ar = 0.0

    for id in 1:n

        ab = _get_absolute_raise(sc_, id, ex)

        ri += ab

        bo = bo_[id]

        if bo

            ri1 += ab

        else

            ri0 += ab

        end

        rin = ri / su

        ri1n = ri1 / su1

        ri0n = ri0 / su0

        le = _get_left(le, pra, ep)

        if prb

            le1 = _get_left(le1, pra, ep)

        else

            le0 = _get_left(le0, pra, ep)

        end

        len = le / su

        le1n = le1 / su1

        le0n = le0 / su0

        en = fu(ri1n, ri0n, rin) - fu(le1n, le0n, len)

        pra = ab

        prb = bo

        if mo

            mo_[id] = en

        end

        ar += en

    end

    ar / n

end

function _enrich(al::KLioP, sc_, ex, bo_, mo_)

    _enrich_klio(BioLab.Information.get_symmetric_kullback_leibler_divergence, sc_, ex, bo_, mo_)

end

function _enrich(al::KLioM, sc_, ex, bo_, mo_)

    _enrich_klio(
        BioLab.Information.get_antisymmetric_kullback_leibler_divergence,
        sc_,
        ex,
        bo_,
        mo_,
    )

end

function enrich(ht, al, sc_, fe_, fe1_::AbstractVector{<:AbstractString}; n = 1, ex = 1, ke_ar...)

    bo_ = BioLab.Collection.is_in(fe_, fe1_)

    if sum(bo_) < n

        return NaN

    end

    mo_ = Vector{Float64}(undef, length(bo_))

    en = _enrich(al, sc_, ex, bo_, mo_)

    _plot_mountain(ht, sc_, fe_, bo_, mo_, en; ke_ar...)

    en

end

function enrich(al, sc_, fe_, fe1___; n = 1, ex = 1)

    en_ = Vector{Float64}(undef, length(fe1___))

    fe_id = Dict(fe => id for (id, fe) in enumerate(fe_))

    for (id, fe1_) in enumerate(fe1___)

        bo_ = BioLab.Collection.is_in(fe_id, fe1_)

        if sum(bo_) < n

            en = NaN

        else

            en = _enrich(al, sc_, ex, bo_, nothing)

        end

        en_[id] = en

    end

    en_

end

function enrich(al, fe_, sa_, fe_x_sa_x_sc, se_, fe1___; n = 1, ex = 1)

    se_x_sa_x_en = Matrix{Float64}(undef, (length(se_), length(sa_)))

    @showprogress for (id, sc_) in enumerate(eachcol(fe_x_sa_x_sc))

        sc2_, fe2_ = BioLab.Vector.skip_nan_sort_like(sc_, fe_; rev = true)

        # TODO: Implement and use enrich! to avoid allocating en_.
        se_x_sa_x_en[:, id] = enrich(al, sc2_, fe2_, fe1___; n, ex)

    end

    se_x_sa_x_en

end

function plot(di, al, fe_, sa_, fe_x_sa_x_sc, se_, fe1___, se_x_sa_x_en, nac; ex = 1)

    BioLab.Path.error_missing(di)

    se_x_sa_x_enm = replace(se_x_sa_x_en, NaN => missing)

    als = make_string(al)

    nacs = BioLab.Path.clean(nac)

    BioLab.Plot.plot_heat_map(
        joinpath(di, "set_x_$(nacs)_x_enrichment.html"),
        se_x_sa_x_enm,
        se_,
        sa_;
        nar = "Set",
        nac,
        layout = Dict("title" => Dict("text" => "Enrichment with $als")),
    )

    for fu in (findmin, findmax)

        en, id_ = fu(skipmissing(se_x_sa_x_enm))

        sc2_, fe2_ = BioLab.Vector.skip_nan_sort_like(fe_x_sa_x_sc[:, id_[2]], fe_; rev = true)

        se = se_[id_[1]]

        sa = sa_[id_[2]]

        en2 = enrich(
            joinpath(di, "$(sa)_enriching_$se.html"),
            al,
            sc2_,
            fe2_,
            fe1___[id_[1]];
            ex,
            title_text = "$sa x $se",
        )

        if en != en2

            error("Enrichemnts do not match. $en != $en2.")

        end

    end

end

end
