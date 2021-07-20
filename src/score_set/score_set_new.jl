using Plotly: Layout

function compute_ks(v1::Vector{Float64}, v2::Vector{Float64})::Vector{Float64}

    return v1 - v2

end

function score_set_new(
    el_::Vector{String},
    sc_::Vector{Float64},
    el1_::Vector{String};
    pl::Bool = true,
    ke...,
)::Float64

    am_ = abs.(sc_)

    boh_ = check_is(el_, el1_)

    bom_ = 1.0 .- boh_

    amh_ = am_ .* boh_

    amm_ = am_ .* bom_

    amp_ = am_ / sum(am_)

    amhp_ = amh_ / sum(amh_)

    ammp_ = amm_ / sum(amm_)

    e = eps()

    ampr_ = cumsum(amp_) .+ e

    amhpr_ = cumsum(amhp_) .+ e

    ammpr_ = cumsum(ammp_) .+ e

    ampl_ = cumulate_sum_reverse(amp_) .+ e

    amhpl_ = cumulate_sum_reverse(amhp_) .+ e

    ammpl_ = cumulate_sum_reverse(ammp_) .+ e

    r = compute_idrd(amhpr_, ammpr_, ampr_)

    l = compute_idrd(amhpl_, ammpl_, ampl_)

    en_ = l - r

    ex = get_extreme(en_)

    ar = get_area(en_)

    if pl

        _plot(el_, sc_, el1_, boh_, en_, ar; ke...)

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
