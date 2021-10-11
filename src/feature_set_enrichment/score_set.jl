using CSV
using DataFrames: DataFrame, names

using ..math: get_center
using ..vector: check_in, sort_like

function _sum_1_absolute_and_0_count(sc_::VF, in_::VF)::Tuple{Float64, Float64}

    su1 = 0.0

    su0 = 0.0

    for ie in 1:length(sc_)

        if in_[ie] == 1.0

            nu = sc_[ie]

            if nu < 0.0

                nu = -nu

            end

            su1 += nu

        else

            su0 += 1.0

        end

    end

    return su1, su0

end

function score_set(
    fe_::VS,
    sc_::VF,
    fe1_::VS,
    in_::VF;
    we::Float64 = 1.0,
    al::String = "ks",
    pl::Bool = true,
    ke_ar...,
)::Float64

    n_fe = length(fe_)

    en = 0.0

    en_ = VF(undef, n_fe)

    ex = 0.0

    exa = 0.0

    ar = 0.0

    su1, su0 = _sum_1_absolute_and_0_count(sc_, in_)

    de = 1.0 / su0

    @inbounds @fastmath @simd for ie in n_fe:-1:1

        if in_[ie] == 1.0

            sc = sc_[ie]

            if sc < 0.0

                sc = -sc

            end

            en += sc / su1

        else

            en -= de

        end

        if pl

            en_[ie] = en

        end

        ar += en

        if en < 0.0

            ena = -en

        else

            ena = en

        end

        if exa < ena

            exa = ena

            ex = en

        end

    end

    if al == "ks"

        en = ex

    elseif al == "auc"

        en = ar / Float64(n_fe)

    end

    if pl

        println("Plotting")

        plot_mountain(fe_, sc_, in_, en_, en; ke_ar...)

    end

    return en

end

function score_set(
    fe_::VS,
    sc_::VF,
    fe1_::VS;
    we::Float64 = 1.0,
    al::String = "ks",
    pl::Bool = true,
    ke_ar...,
)::Float64

    return score_set(
        fe_,
        sc_,
        fe1_,
        check_in(fe_, fe1_);
        we = we,
        al = al,
        pl = pl,
        ke_ar...,
    )

end

function score_set(
    fe_::VS,
    sc_::VF,
    se_fe_::DSVS;
    we::Float64 = 1.0,
    al::String = "ks",
)::DSF

    if length(se_fe_) < 10

        ch = fe_

    else

        ch = Dict(fe => ie for (fe, ie) in zip(fe_, 1:length(fe_)))

    end

    se_en = DSF()

    for (se, fe1_) in se_fe_

        se_en[se] = score_set(
            fe_,
            sc_,
            fe1_,
            check_in(ch, fe1_);
            we = we,
            al = al,
            pl = false,
        )

    end

    return se_en

end

function score_set(
    sc_fe_sa::DataFrame,
    se_fe_::DSVS;
    we::Float64 = 1.0,
    al::String = "ks",
    n_jo::Int64 = 1,
)::DataFrame

    fe_ = sc_fe_sa[!, 1]

    en_se_sa = DataFrame(:Set => collect(keys(se_fe_)))

    for sa in names(sc_fe_sa)[2:end]

        go_ = findall(!ismissing, sc_fe_sa[!, sa])

        sc_, fe_ = sort_like(sc_fe_sa[go_, sa], fe_[go_])

        if in(al, ["ks", "auc"])

            se_en = score_set(fe_, sc_, se_fe_; we = we, al = al)

        elseif al == "js"

            se_en = score_set_new(fe_, sc_, se_fe_)

        end

        en_se_sa[!, sa] = collect(se_en[se] for se in en_se_sa[!, :Set])

    end

    return en_se_sa

end

export score_set
