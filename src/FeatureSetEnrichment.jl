module FeatureSetEnrichment

using DataFrames: DataFrame

using StatsBase: mean, sample

using ..BioLab

struct KS end

struct KSa end

struct KLi end

struct KLioP end

struct KLioM end

function _get_absolute_raise(sc_, id, ex)

    ab = sc_[id]

    if ab < 0.0

        ab = -ab

    end

    if ex != 1.0

        ab ^= ex

    end

    return ab

end

function _sum_1_and_0(sc_, bo_, ex)

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

    return n, su1, su0

end

function _sum_all_and_1(sc_, bo_, ex)

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

    return n, su, su1

end

function _plot_mountain(
    fe_,
    sc_,
    bo_,
    en_,
    en;
    title_text = "Set Enrichment",
    fe = "Feature",
    sc = "Score",
    lo = "Low",
    hi = "High",
    ht = "",
)

    n = length(fe_)

    width = 800

    height = width / MathConstants.golden

    axis = Dict("zeroline" => false, "showgrid" => false)

    yaxis1_domain = (0.0, 0.24)

    yaxis2_domain = (0.25, 0.31)

    yaxis3_domain = (0.32, 1.0)

    xaxis_range_margin = n * 0.01

    axis_title_font_size = 12

    borderwidth = 2

    annotation =
        Dict("yref" => "paper", "xref" => "paper", "yanchor" => "middle", "showarrow" => false)

    annotationy = merge(
        annotation,
        Dict("x" => -0.1, "textangle" => -90, "font" => Dict("size" => axis_title_font_size)),
    )

    annotationx =
        merge(annotation, Dict("x" => 0.5, "font" => Dict("size" => axis_title_font_size)))

    annotations = merge(
        annotation,
        Dict(
            "y" => mean(yaxis1_domain),
            "font" => Dict("size" => 10),
            "bgcolor" => "#ffffff",
            "borderpad" => 2,
            "borderwidth" => borderwidth,
        ),
    )

    annotations_margin = 0.02

    coe1 = "#07fa07"

    coe2 = "rgba(7, 250, 7, 0.32)"

    coe3 = "rgba(7, 250, 7, 0.08)"

    layout = Dict(
        "height" => height,
        "width" => width,
        "showlegend" => false,
        "yaxis" => merge(axis, Dict("domain" => yaxis1_domain, "ticks" => "outside")),
        "yaxis2" => merge(
            axis,
            Dict("domain" => yaxis2_domain, "ticks" => "", "showticklabels" => false),
        ),
        "yaxis3" => merge(axis, Dict("domain" => yaxis3_domain, "ticks" => "outside")),
        "xaxis" => merge(
            axis,
            Dict(
                "range" => (1 - xaxis_range_margin, n + xaxis_range_margin),
                "showspikes" => true,
                "spikemode" => "across",
                "spikedash" => "solid",
                "spikethickness" => 0.69,
                "spikecolor" => "#ffb61e",
            ),
        ),
        "annotations" => (
            merge(
                annotationx,
                Dict(
                    "y" => 1.24,
                    "text" => "<b>$(BioLab.String.limit(title_text, 32))</b>",
                    "font" => Dict("size" => 32, "family" => "Relaway", "color" => "#2b2028"),
                ),
            ),
            merge(
                annotationx,
                Dict(
                    "y" => 1.08,
                    "text" => "Enrichment: <b>$(BioLab.Number.format(en))</b>",
                    "font" => Dict("size" => 16, "color" => "#181b26"),
                    "bgcolor" => coe3,
                    "borderpad" => 8,
                    "borderwidth" => borderwidth,
                    "bordercolor" => coe2,
                ),
            ),
            merge(annotationy, Dict("y" => mean(yaxis1_domain), "text" => "<b>$sc</b>")),
            merge(annotationy, Dict("y" => mean(yaxis2_domain), "text" => "<b>Set</b>")),
            merge(annotationy, Dict("y" => mean(yaxis3_domain), "text" => "<b>Enrichment</b>")),
            merge(
                annotationx,
                Dict(
                    "y" => -0.132,
                    "text" => "<b>$fe (n=$n)</b>",
                    "font" => Dict("size" => axis_title_font_size),
                ),
            ),
            merge(
                annotations,
                Dict(
                    "y" => yaxis1_domain[2] * 1 / 4,
                    "x" => annotations_margin,
                    "text" => hi,
                    "font" => Dict("color" => "#ff1992"),
                    "bordercolor" => "#fcc9b9",
                ),
            ),
            merge(
                annotations,
                Dict(
                    "y" => yaxis1_domain[2] * 3 / 4,
                    "x" => 1 - annotations_margin,
                    "text" => lo,
                    "font" => Dict("color" => "#1993ff"),
                    "bordercolor" => "#b9c9fc",
                ),
            ),
        ),
    )

    x = collect(1:n)

    trace_ = [
        Dict(
            "y" => sc_,
            "x" => x,
            "text" => fe_,
            "mode" => "lines",
            "line" => Dict("width" => 1.6, "color" => "#351e1c"),
            "fill" => "tozeroy",
            "fillcolor" => "#c0c0c0",
        ),
        Dict(
            "yaxis" => "y2",
            "y" => fill(0, sum(bo_)),
            "x" => x[bo_],
            "text" => fe_[bo_],
            "mode" => "markers",
            "marker" => Dict(
                "symbol" => "line-ns",
                "size" => height * (yaxis2_domain[2] - yaxis2_domain[1]),
                "line" => Dict(
                    "width" => 1.08,
                    "color" => [
                        BioLab.Plot.color(BioLab.Plot.COBWR, convert(Float64, sc))
                        for sc in sc_[bo_]
                    ],
                ),
            ),
            "hoverinfo" => "x+text",
        ),
        Dict(
            "yaxis" => "y3",
            "y" => en_,
            "x" => x,
            "text" => fe_,
            "mode" => "lines",
            "line" => Dict("width" => 3.2, "color" => coe1),
            "fill" => "tozeroy",
            "fillcolor" => coe2,
        ),
    ]

    return BioLab.Plot.plot(trace_, layout; ht)

end

function _score_set(al::KS, fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    n, su1, su0 = _sum_1_and_0(sc_, bo_, ex)

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

        _plot_mountain(fe_, sc_, bo_, en_, et; ke_ar...)

    end

    return et

end

function _score_set(al::KSa, fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    n, su1, su0 = _sum_1_and_0(sc_, bo_, ex)

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

        _plot_mountain(fe_, sc_, bo_, en_, ar; ke_ar...)

    end

    return ar

end

function _clip(le, pr, mi)

    le -= pr

    if le < mi

        le = mi

    end

    return le

end

function _score_set(al::KLi, fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    n, su, su1 = _sum_all_and_1(sc_, bo_, ex)

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

        le = _clip(le, pra, ep)

        if prb

            le1 = _clip(le1, pra, ep)

        end

        len = le / su

        le1n = le1 / su1

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

        _plot_mountain(fe_, sc_, bo_, en_, ar; ke_ar...)

    end

    return ar

end

function _score_set_klio(fe_, sc_, bo_, fu; ex = 1.0, pl = true, ke_ar...)

    n, su, su1 = _sum_all_and_1(sc_, bo_, ex)

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

        le = _clip(le, pra, ep)

        if prb

            le1 = _clip(le1, pra, ep)

        else

            le0 = _clip(le0, pra, ep)

        end

        len = le / su

        le1n = le1 / su1

        le0n = le0 / su0

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

        _plot_mountain(fe_, sc_, bo_, en_, ar; ke_ar...)

    end

    return ar

end

function _score_set(al::KLioP, fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    return _score_set_klio(fe_, sc_, bo_, (_1, _0) -> _1 + _0; ex, pl, ke_ar...)

end

function _score_set(al::KLioM, fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    return _score_set_klio(fe_, sc_, bo_, (_1, _0) -> _1 - _0; ex, pl, ke_ar...)

end

function score_set(
    al,
    fe_,
    sc_,
    fe1_::AbstractVector{<:AbstractString};
    ex = 1.0,
    pl = true,
    ke_ar...,
)

    return _score_set(al, fe_, sc_, BioLab.Collection.is_in(fe_, Set(fe1_)); ex, pl, ke_ar...)

end

function score_set(al, fe_, sc_, fe1___; ex = 1.0)

    ch = Dict(fe => id for (id, fe) in enumerate(fe_))

    return [
        _score_set(al, fe_, sc_, BioLab.Collection.is_in(ch, fe1_); ex, pl = false) for
        fe1_ in fe1___
    ]

end

function score_set(al, feature_x_sample_x_score::DataFrame, se_, fe1___; ex = 1.0, n_jo = 1)

    _fen, fe_::Vector{String}, sa_::Vector{String}, fe_x_sa_x_sc::Matrix{Float64} =
        BioLab.DataFrame.separate(feature_x_sample_x_score)

    BioLab.Array.error_duplicate(fe_)

    # TODO: Use `Matrix`.
    se_x_sa_x_en = DataFrame("Set" => se_)

    # TODO: Parallelize.
    for (id, sa) in enumerate(sa_)

        go_ = findall(!ismissing, fe_x_sa_x_sc[:, id])

        sc_, fe_ = BioLab.Collection.sort_like((fe_x_sa_x_sc[go_, id], fe_[go_]); ic = false)

        se_x_sa_x_en[!, sa] = score_set(al, fe_, sc_, fe1___; ex)

    end

    return se_x_sa_x_en

end

function benchmark_card(ca1)

    return reverse!([string(ca) for ca in BioLab.CA_]),
    reverse!(collect(-6:6)),
    [string(ca) for ca in ca1]

end

function benchmark_random(n, n1)

    fe_ = ["Feature $id" for id in 1:n]

    # TODO: Check.
    return reverse!(fe_),
    reverse!(BioLab.VectorNumber.simulate(cld(n, 2); ev = iseven(n))),
    sample(fe_, n1; replace = false)

end

function benchmark_myc()::Tuple{Vector{String}, Vector{Float64}, Vector{String}}

    di = pkgdir(BioLab, "test", "FeatureSetEnrichment.data")

    da = BioLab.Table.read(joinpath(di, "gene_x_statistic_x_number.tsv"))

    return reverse!(da[!, 1]),
    reverse!(da[!, 2]),
    BioLab.GMT.read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

end

end
