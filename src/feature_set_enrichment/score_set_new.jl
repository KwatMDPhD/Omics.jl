using ..vector: check_in
using ..vector_number: cumulate_sum_reverse, get_area
using ..information: compute_idrd

function score_set_new(
    el_::Vector{String},
    sc_::Vector{Float64},
    el1_::Vector{String};
    pl::Bool = true,
    ke...,
)::Float64

    ab_ = abs.(sc_)

    bo1_ = check_in(el_, el1_)

    bo0_ = 1.0 .- bo1_

    ab1_ = ab_ .* bo1_

    ab0_ = ab_ .* bo0_

    abp_ = ab_ / sum(ab_)

    ab1p_ = ab1_ / sum(ab1_)

    ab0p_ = ab0_ / sum(ab0_)

    ep = eps()

    abpr_ = cumsum(abp_) .+ ep

    ab1pr_ = cumsum(ab1p_) .+ ep

    ab0pr_ = cumsum(ab0p_) .+ ep

    abpl_ = cumulate_sum_reverse(abp_) .+ ep

    ab1pl_ = cumulate_sum_reverse(ab1p_) .+ ep

    ab0pl_ = cumulate_sum_reverse(ab0p_) .+ ep

    ri = compute_idrd(ab1pr_, ab0pr_, abpr_)

    le = compute_idrd(ab1pl_, ab0pl_, abpl_)

    en_ = le - ri

    ar = get_area(en_)

    if pl

        plot_mountain(el_, sc_, bo1_, en_, ar; ke...)

    end

    return ar

end

function score_set_new(
    el_::Vector{String},
    sc_::Vector{Float64},
    se_el1_::Dict{String,Vector{String}};
)::Dict{String,Float64}

    se_en = Dict{String,Float64}()

    for (se, el1_) in se_el1_

        se_en[se] = score_set_new(el_, sc_, el1_; pl = false)

    end

    return se_en

end

export score_set_new
