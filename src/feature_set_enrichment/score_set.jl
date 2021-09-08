using CSV
using DataFrames: DataFrame, names

using ..math: get_center
using ..vector: check_in, sort_like

function score_set(
    fe_::Vector{String},
    sc_::Vector{Float64},
    fe1_::Vector{String},
    bo_::Vector{Float64};
    we::Float64 = 1.0,
    al::String = "ks",
    pl::Bool = true,
    ke...,
)::Float64

    n_fe = length(fe_)

    en = 0.0

    en_ = Vector{Float64}(undef, n_fe)

    ex = 0.0

    exa = 0.0

    ar = 0.0

    su1, su0 = sum_1_absolute_n_0(sc_, bo_)

    de = 1.0 / su0

    @inbounds @fastmath @simd for ie = n_fe:-1:1

        if bo_[ie] == 1.0

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

        en = ar / convert(Float64, n_fe)

    end

    if pl

        plot_mountain(fe_, sc_, bo_, en_, en; ke...)

    end

    return en

end

function score_set(
    fe_::Vector{String},
    sc_::Vector{Float64},
    fe1_::Vector{String};
    we::Float64 = 1.0,
    al::String = "ks",
    pl::Bool = true,
    ke...,
)::Float64

    return score_set(fe_, sc_, fe1_, check_in(fe_, fe1_); we = we, al = al, pl = pl, ke...)

end

function score_set(
    fe_::Vector{String},
    sc_::Vector{Float64},
    se_fe_::Dict{String,Vector{String}};
    we::Float64 = 1.0,
    al::String = "ks",
)::Dict{String,Float64}

    if length(se_fe_) < 10

        ch = fe_

    else

        ch = Dict(fe => ie for (fe, ie) in zip(fe_, 1:length(fe_)))

    end

    se_en = Dict{String,Float64}()

    for (se, fe1_) in se_fe_

        se_en[se] =
            score_set(fe_, sc_, fe1_, check_in(ch, fe1_); we = we, al = al, pl = false)

    end

    return se_en

end

function score_set(
    sc_fe_sa::DataFrame,
    se_fe_::Dict{String,Vector{String}};
    we::Float64 = 1.0,
    al::String = "ks",
    n_jo::Int64 = 1,
)::DataFrame

    fe_ = sc_fe_sa[!, 1]

    en_se_sa = DataFrame(:Set => collect(keys(se_fe_)))

    for sa in names(sc_fe_sa)[2:end]

        bo_ = findall(!ismissing, sc_fe_sa[!, sa])

        sc_, fe_ = sort_like(sc_fe_sa[bo_, sa], fe_[bo_])

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
