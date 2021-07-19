using CSV
using DataFrames: DataFrame, names

using Kwat.Support: check_is, sort_like

include("_plot.jl")

function score_set(
    el_::Vector{String},
    sc_::Vector{Float64},
    el1_::Vector{String},
    bo_::Vector{Float64};
    pl::Bool = true,
    ke...,
)::Tuple{Vector{Float64},Float64,Float64}

    n_el = length(el_)

    en = 0.0

    en_ = Vector{Float64}(undef, n_el)

    ex = 0.0

    exab = 0.0

    ar = 0.0

    su1, su0 = sum_h_absolute_and_n_m(sc_, bo_)

    d0 = 1.0 / su0

    @inbounds @fastmath @simd for ie = n_el:-1:1

        if bo_[ie] == 1.0

            sc = sc_[ie]

            if sc < 0.0

                sc = -sc

            end

            en += sc / su1

        else

            en -= d0

        end

        if pl

            en_[ie] = en

        end

        if en < 0.0

            enab = -en

        else

            enab = en

        end

        if exab < enab

            ex = en

            exab = enab

        end

        ar += en

    end

    if pl

        _plot(el_, sc_, el1_, bo_, en_, ar; ke...)

    end

    return en_, ex, ar / convert(Float64, n_el)

end

function score_set(
    el_::Vector{String},
    sc_::Vector{Float64},
    el1_::Vector{String};
    so::Bool = true,
    pl::Bool = true,
    ke...,
)::Tuple{Vector{Float64},Float64,Float64}

    if so

        sc_, el_ = sort_like(sc_, el_)

    end

    return score_set(el_, sc_, el1_, check_is(el_, el1_); pl = pl, ke...)

end

function score_set(
    el_::Vector{String},
    sc_::Vector{Float64},
    se_el1_::Dict{String,Vector{String}};
    so::Bool = true,
)::Dict{String,Tuple{Vector{Float64},Float64,Float64}}

    if so

        sc_, el_ = sort_like(sc_, el_)

    end

    if 10 < length(se_el1_)

        ch = Dict(el => ie for (el, ie) in zip(el_, 1:length(el_)))

    else

        ch = el_

    end

    se_di = Dict{String,Tuple{Vector{Float64},Float64,Float64}}()

    for (set, el1_) in se_el1_

        se_di[set] = score_set(el_, sc_, el1_, check_is(ch, el1_); pl = false)

    end

    return se_di

end

function score_set(
    sc_el_sa::DataFrame,
    se_el1_::Dict{String,Vector{String}};
    me::String = "classic",
    n_jo::Int64 = 1,
)::DataFrame

    el_ = sc_el_sa[!, 1]

    en_se_sa = DataFrame(:Set => sort(collect(keys(se_el1_))))

    for sa in names(sc_el_sa)[2:end]

        bo_ = findall(!ismissing, sc_el_sa[!, sa])

        if me == "classic"

            fu = score_set

        elseif me == "new"

            fu = score_set_new

        end

        se_di = fu(el_[bo_], sc_el_sa[bo_, sa], se_el1_)

        en_se_sa[!, sa] = collect(se_di[set][end] for set in en_se_sa[!, :Set])

    end

    return en_se_sa

end

export score_set
