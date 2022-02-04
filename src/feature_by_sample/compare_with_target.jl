using ..information: get_signal_to_noise_ratio
using ..tensor_function: apply

function compare_with_target(
    sa_::Union{Vector{Float64},BitVector},
    fl_fe_sa::Matrix{Float64},
    fu::String,
)::Vector{Float64}

    if fu == "signal_to_noise_ratio"

        fu = get_signal_to_noise_ratio

        sa_ = convert(BitVector, sa_)

    elseif fu == "pearson_correlation"

    elseif fu == "cosine_distance"

    end

    return apply(sa_, fl_fe_sa, fu)

end
