using CSV
using DataFrames: DataFrame, names

using ..math: get_center
using ..vector: check_in, sort_like

# TODO: weigh
function score_set(
    el_::Vector{String},
    sc_::Vector{Float64},
    el1_::Vector{String},
    bo_::Vector{Float64};
    we::Float64 = 1.0,
    al::String = "ks",
    pl::Bool = true,
    ke...,
)::Float64

    n_el = length(el_)

    en = 0.0

    en_ = Vector{Float64}(undef, n_el)

    ex = 0.0

    exa = 0.0

    ar = 0.0

    su1, su0 = sum_1_absolute_n_0(sc_, bo_)

    de = 1.0 / su0

    @inbounds @fastmath @simd for ie = n_el:-1:1

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

        en = ar / convert(Float64, n_el)

    end

    if pl

        plot_mountain(el_, sc_, bo_, en_, en; ke...)

    end

    return en

end

function score_set(
    el_::Vector{String},
    sc_::Vector{Float64},
    el1_::Vector{String};
    we::Float64 = 1.0,
    al::String = "ks",
    pl::Bool = true,
    ke...,
)::Float64

    return score_set(el_, sc_, el1_, check_in(el_, el1_); we = we, al = al, pl = pl, ke...)

end

function score_set(
    el_::Vector{String},
    sc_::Vector{Float64},
    se_el_::Dict{String,Vector{String}};
    we::Float64 = 1.0,
    al::String = "ks",
)::Dict{String,Float64}

    if length(se_el_) < 10

        ch = el_

    else

        ch = Dict(el => ie for (el, ie) in zip(el_, 1:length(el_)))

    end

    se_en = Dict{String,Float64}()

    for (se, el1_) in se_el_

        se_en[se] =
            score_set(el_, sc_, el1_, check_in(ch, el1_); we = we, al = al, pl = false)

    end

    return se_en

end

# TODO: parallelize
function score_set(
    sc_el_sa::DataFrame,
    se_el_::Dict{String,Vector{String}};
    we::Float64 = 1.0,
    al::String = "ks",
    n_jo::Int64 = 1,
)::DataFrame

    el_ = sc_el_sa[!, 1]

    en_se_sa = DataFrame(:Set => collect(keys(se_el_)))

    for sa in names(sc_el_sa)[2:end]

        bo_ = findall(!ismissing, sc_el_sa[!, sa])

        sc_, el_ = sort_like(sc_el_sa[bo_, sa], el_[bo_])

        if in(al, ["ks", "auc"])

            se_en = score_set(el_, sc_, se_el_; we = we, al = al)

        elseif al == "js"

            se_en = score_set_new(el_, sc_, se_el_)

        end

        en_se_sa[!, sa] = collect(se_en[se] for se in en_se_sa[!, :Set])

    end

    return en_se_sa

end

export score_set
