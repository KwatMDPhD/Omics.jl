module FeatureSetEnrichment

using DataFrames: DataFrame

using StatsBase: sample

using ..BioLab

struct KS end

struct KSa end

struct KLi end

struct KLioP end

struct KLioM end

function _get_absolute_raise(sc_, id, ex)

    abe = sc_[id]

    if abe < 0.0

        abe = -abe

    end

    if ex != 1.0

        abe ^= ex

    end

    return abe

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

        abe = _get_absolute_raise(sc_, id, ex)

        su += abe

        if bo_[id]

            su1 += abe

        end

    end

    return n, su, su1

end

function _range(di_)

    return di_[2] - di_[1]

end

function _mean(di_)

    return (di_[1] + di_[2]) / 2

end

function _plot_mountain(
    fe_,
    sc_,
    bo_,
    en_,
    en;
    title_text = "Mountain Plot",
    fe = "Feature",
    sc = "Score",
    title_font_size = 24,
    statistic_font_size = 16,
    axis_title_font_size = 12,
    ht = "",
)

    width = 800

    height = width / MathConstants.golden

    yaxis1_domain = (0.0, 0.24)

    yaxis2_domain = (0.24, 0.32)

    yaxis3_domain = (0.32, 1.0)

    annotation =
        Dict("yref" => "paper", "xref" => "paper", "yanchor" => "middle", "showarrow" => false)

    annotationy = merge(
        annotation,
        Dict("xanchor" => "right", "x" => -0.064, "font" => Dict("size" => axis_title_font_size)),
    )

    annotationx = merge(annotation, Dict("xanchor" => "center", "x" => 0.5))

    title_text = BioLab.String.limit(title_text, 32)

    n = length(fe_)

    layout = Dict(
        "height" => height,
        "width" => width,
        "margin" => Dict(
            "t" => round(height * 0.24),
            "b" => round(height * 0.088),
            "l" => round(width * 0.19),
        ),
        "showlegend" => false,
        "yaxis" => Dict("domain" => yaxis1_domain, "showline" => true, "showgrid" => false),
        "yaxis2" =>
            Dict("domain" => yaxis2_domain, "showticklabels" => false, "showgrid" => false),
        "yaxis3" => Dict("domain" => yaxis3_domain, "showline" => true, "showgrid" => false),
        "xaxis" => Dict(
            "zeroline" => false,
            "showgrid" => false,
            "showspikes" => true,
            "spikethickness" => 1.08,
            "spikecolor" => "#ffb61e",
            "spikedash" => "solid",
            "spikemode" => "across",
        ),
        "annotations" => (
            merge(
                annotationx,
                Dict(
                    "y" => 1.29,
                    "text" => "<b>$title_text</b>",
                    "font" => Dict("size" => title_font_size, "color" => "#2b2028"),
                ),
            ),
            merge(
                annotationx,
                Dict(
                    "y" => 1.16,
                    "text" => "Enrichment: <b>$(BioLab.Number.format(en))</b>",
                    "font" => Dict("size" => statistic_font_size, "color" => "#181b26"),
                    "bgcolor" => "#ebf6f7",
                    "bordercolor" => "#404ed8",
                    "borderpad" => 6.4,
                ),
            ),
            merge(annotationy, Dict("y" => _mean(yaxis1_domain), "text" => "<b>$sc</b>")),
            merge(annotationy, Dict("y" => _mean(yaxis2_domain), "text" => "<b>Set</b>")),
            merge(annotationy, Dict("y" => _mean(yaxis3_domain), "text" => "<b>Enrichment</b>")),
            merge(
                annotationx,
                Dict(
                    "y" => -0.088,
                    "text" => "<b>$fe (n=$n)</b>",
                    "font" => Dict("size" => axis_title_font_size),
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
            "line" => Dict("width" => 0),
            "fill" => "tozeroy",
            "fillcolor" => "#20d9ba",
            "hoverinfo" => "x+y+text",
        ),
        Dict(
            "yaxis" => "y2",
            "y" => fill(0, sum(bo_)),
            "x" => x[bo_],
            "text" => fe_[bo_],
            "mode" => "markers",
            "marker" => Dict(
                "symbol" => "line-ns",
                "size" => height * _range(yaxis2_domain) * 0.32,
                "line" => Dict("width" => 2.4, "color" => "#9017e6"),
            ),
            "hoverinfo" => "x+text",
        ),
    ]

    le_ = (en < 0.0 for en in en_)

    for (is_, fillcolor) in ((le_, "#1992ff"), ((!le for le in le_), "#ff1993"))

        push!(
            trace_,
            Dict(
                "yaxis" => "y3",
                "y" => [ifelse(is, en, 0.0) for (is, en) in zip(is_, en_)],
                "x" => x,
                "text" => fe_,
                "mode" => "lines",
                "line" => Dict("width" => 0),
                "fill" => "tozeroy",
                "fillcolor" => fillcolor,
                "hoverinfo" => "x+y+text",
            ),
        )

    end

    ex_ = BioLab.VectorNumber.get_extreme(en_)

    id_ = findall(en in ex_ for en in en_)

    push!(
        trace_,
        Dict(
            "yaxis" => "y3",
            "y" => en_[id_],
            "x" => x[id_],
            "mode" => "markers",
            "marker" => Dict(
                "symbol" => "circle",
                "size" => height * _range(yaxis3_domain) * 0.04,
                "color" => "#ebf6f7",
                "opacity" => 0.72,
                "line" => Dict("width" => 2, "color" => "#404ed8", "opacity" => 0.88),
            ),
            "hoverinfo" => "y",
        ),
    )

    return BioLab.Plot.plot(trace_, layout; ht)

end

function benchmark_card(ca1)

    return BioLab.CA_, collect(-6:6), collect(ca1)

end

function benchmark_random(n, n1)

    fe_ = ["Feature $id" for id in 1:n]

    fe_, BioLab.VectorNumber.simulate(cld(n, 2); ev = iseven(n)), sample(fe_, n1; replace = false)

end

function benchmark_myc()::Tuple{Vector{String}, Vector{Float64}, Vector{String}}

    di = joinpath(pkgdir(BioLab), "test", "FeatureSetEnrichment.data")

    da = BioLab.Table.read(joinpath(di, "gene_x_statistic_x_number.tsv"))

    da[!, 1],
    da[!, 2],
    BioLab.GMT.read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

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

function score_set(al, fe_, sc_, fe1_::AbstractVector; ex = 1.0, pl = true, ke_ar...)

    return _score_set(al, fe_, sc_, BioLab.Collection.is_in(fe_, Set(fe1_)); ex, pl, ke_ar...)

end

function score_set(al, fe_, sc_, se_fe_; ex = 1.0)

    ch = Dict(fe => id for (id, fe) in enumerate(fe_))

    #sc_, fe_ = BioLab.Collection.sort_like((sc_, fe_); ic=false)

    return Dict(
        se => _score_set(al, fe_, sc_, BioLab.Collection.is_in(ch, fe1_); ex, pl = false) for
        (se, fe1_) in se_fe_
    )

end

function score_set(al, fe_x_sa_x_sc, se_fe_; ex = 1.0, n_jo = 1)

    fe_::Vector{String}, sa_::Vector{String}, fe_x_sa_x_sc::Matrix{Float64} =
        BioLab.DataFrame.separate(fe_x_sa_x_sc)[[2, 3, 4]]

    BioLab.Array.error_duplicate(fe_)

    #BioLab.Matrix.error_bad(fe_x_sa_x_sc, Float64)

    se_x_sa_x_en = DataFrame("Set" => collect(keys(se_fe_)))

    # TODO: Parallelize.
    for (id, sa) in enumerate(sa_)

        go_ = findall(!ismissing, fe_x_sa_x_sc[:, id])

        sc_, fe_ = BioLab.Collection.sort_like((fe_x_sa_x_sc[go_, id], fe_[go_]); ic = false)

        se_en = score_set(al, fe_, sc_, se_fe_; ex)

        se_x_sa_x_en[!, sa] = [se_en[se] for se in se_x_sa_x_en[!, "Set"]]

    end

    return se_x_sa_x_en

end

end
