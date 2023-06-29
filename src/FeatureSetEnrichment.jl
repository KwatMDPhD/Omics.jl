module FeatureSetEnrichment

using ProgressMeter: @showprogress

using StatsBase: mean, sample

using ..BioLab

struct KS end

struct KSa end

struct KLi end

struct KLioP end

struct KLioM end

function _get_absolute_raise(sc_, id, ex)

    ab = sc_[id]

    ab = flipsign(ab, ab)

    if ex != 1.0

        ab ^= ex

    end

    ab

end

function _sum_10(sc_, bo_, ex)

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

function _sum_all1(sc_, bo_, ex)

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

function _make_annotation(ke_va__...)

    BioLab.Plot.make_annotation(
        Dict("bgcolor" => "#fcfcfc", "borderpad" => 4, "borderwidth" => 2),
        ke_va__...,
    )

end

function _plot_mountain(
    ht,
    fe_,
    sc_,
    bo_,
    en_,
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

    yaxis1_domain = (0.0, 0.24)

    yaxis2_domain = (0.25, 0.31)

    yaxis3_domain = (0.32, 1.0)

    # TODO
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
                        "color" =>
                            map(sc -> BioLab.Plot.color(BioLab.Plot.COBWR, sc), sc_[bo_]),
                    ),
                ),
                "hoverinfo" => "x+text",
            ),
            BioLab.Dict.merge(
                scatter,
                Dict(
                    "yaxis" => "y3",
                    "y" => en_,
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
                Dict(
                    # TODO
                    #"range" => (1 - xaxis_range_margin, n + xaxis_range_margin),
                    "showspikes" => true,
                    "spikemode" => "across",
                    "spikedash" => "solid",
                    "spikethickness" => 0.69,
                    "spikecolor" => "#ffb61e",
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

# TODO: Try Type{}.

function _enrich(al::KS, fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    n, su1, su0 = _sum_10(sc_, bo_, ex)

    cu = 0.0

    de = 1.0 / su0

    if pl

        en_ = Vector{Float64}(undef, n)

    end

    eta = 0.0

    et = 0.0

    for id in 1:n

        if bo_[id]

            cu += _get_absolute_raise(sc_, id, ex) / su1

        else

            cu -= de

        end

        if pl

            en_[id] = cu

        end

        # TODO: flipsign.

        if cu < 0.0

            cua = -cu

        else

            cua = cu

        end

        if eta < cua

            eta = cua

            et = cu

        end

    end

    if pl

        ht = ""

        _plot_mountain(ht, fe_, sc_, bo_, en_, et; ke_ar...)

    end

    et

end

function _enrich(al::KSa, fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    n, su1, su0 = _sum_10(sc_, bo_, ex)

    cu = 0.0

    de = 1.0 / su0

    if pl

        en_ = Vector{Float64}(undef, n)

    end

    ar = 0.0

    for id in 1:n

        if bo_[id]

            cu += _get_absolute_raise(sc_, id, ex) / su1

        else

            cu -= de

        end

        if pl

            en_[id] = cu

        end

        ar += cu

    end

    ar /= n

    if pl

        ht = ""

        _plot_mountain(ht, fe_, sc_, bo_, en_, ar; ke_ar...)

    end

    ar

end

function _minus_clip(le, pr, mi)

    le -= pr

    if le < mi

        le = mi

    end

    le

end

function _enrich(al::KLi, fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    n, su, su1 = _sum_all1(sc_, bo_, ex)

    ep = eps()

    ri = ep

    ri1 = ep

    le = su

    le1 = su1

    pra = 0.0

    prb = false

    if pl

        en_ = Vector{Float64}(undef, n)

    end

    ar = 0.0

    for id in 1:n

        abe = _get_absolute_raise(sc_, id, ex)

        ri += abe

        bo = bo_[id]

        if bo

            ri1 += abe

        end

        rin = ri / su

        ri1n = ri1 / su1

        le = _minus_clip(le, pra, ep)

        if prb

            le1 = _minus_clip(le1, pra, ep)

        end

        len = le / su

        le1n = le1 / su1

        # TODO: use BioLab.Information.
        en = ri1n * log(ri1n / rin) - le1n * log(le1n / len)

        pra = abe

        prb = bo

        if pl

            en_[id] = en

        end

        ar += en

    end

    ar /= n

    if pl

        ht = ""

        _plot_mountain(ht, fe_, sc_, bo_, en_, ar; ke_ar...)

    end

    ar

end

function _enrich_klio(fu, fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    n, su, su1 = _sum_all1(sc_, bo_, ex)

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

    if pl

        en_ = Vector{Float64}(undef, n)

    end

    ar = 0.0

    for id in 1:n

        abe = _get_absolute_raise(sc_, id, ex)

        ri += abe

        bo = bo_[id]

        if bo

            ri1 += abe

        else

            ri0 += abe

        end

        rin = ri / su

        ri1n = ri1 / su1

        ri0n = ri0 / su0

        le = _minus_clip(le, pra, ep)

        if prb

            le1 = _minus_clip(le1, pra, ep)

        else

            le0 = _minus_clip(le0, pra, ep)

        end

        len = le / su

        le1n = le1 / su1

        le0n = le0 / su0

        # TODO: use BioLab.Information.
        en =
            fu(ri1n * log(ri1n / rin), ri0n * log(ri0n / rin)) -
            fu(le1n * log(le1n / len), le0n * log(le0n / len))

        pra = abe

        prb = bo

        if pl

            en_[id] = en

        end

        ar += en

    end

    ar /= n

    if pl

        ht = ""

        _plot_mountain(ht, fe_, sc_, bo_, en_, ar; ke_ar...)

    end

    ar

end

function _enrich(al::KLioP, fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    _enrich_klio((_1, _0) -> _1 + _0, fe_, sc_, bo_; ex, pl, ke_ar...)

end

function _enrich(al::KLioM, fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    _enrich_klio((_1, _0) -> _1 - _0, fe_, sc_, bo_; ex, pl, ke_ar...)

end

function enrich(
    al,
    fe_,
    sc_,
    fe1_::AbstractVector{<:AbstractString};
    ex = 1.0,
    pl = true,
    ke_ar...,
)

    # TODO: Try without Set.
    _enrich(al, fe_, sc_, BioLab.Collection.is_in(fe_, Set(fe1_)); ex, pl, ke_ar...)

end

function enrich(al, fe_, sc_, fe1___; ex = 1.0)

    ch = Dict(naf => id for (id, naf) in enumerate(fe_))

    # TODO: map.
    [_enrich(al, fe_, sc_, BioLab.Collection.is_in(ch, fe1_); ex, pl = false) for fe1_ in fe1___]

end

function enrich(al, fe_, sa_, fe_x_sa_x_sc, se_, fe1___; ex = 1.0)

    n = length(sa_)

    se_x_sa_x_en = Matrix{Float64}(undef, (length(se_), n))

    @showprogress for id in 1:n

        sc_ = fe_x_sa_x_sc[:, id]

        go_ = findall(!isnan, sc_)

        sc_, fe_ = BioLab.Vector.sort_like((sc_[go_], fe_[go_]); rev = true)

        se_x_sa_x_en[:, id] = enrich(al, fe_, sc_, fe1___; ex)

    end

    se_x_sa_x_en

end

# TODO: Decouple benchmarking.

function benchmark_card(ca1)

    ["K", "Q", "J", "X", "9", "8", "7", "6", "5", "4", "3", "2", "A"],
    [6.0, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6],
    [string(ca) for ca in ca1]

end

function benchmark_random(n, n1)

    fe_ = map(id -> "Feature $id", n:-1:1)

    fe_,
    reverse!(BioLab.NumberVector.simulate(cld(n, 2); ze = iseven(n))),
    sample(fe_, n1; replace = false)

end

function benchmark_myc()

    di = joinpath(BioLab.DA, "FeatureSetEnrichment")

    da = BioLab.Table.read(joinpath(di, "gene_x_statistic_x_number.tsv"))

    reverse!(da[!, 1]),
    reverse!(da[!, 2]),
    BioLab.GMT.read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

end

end
