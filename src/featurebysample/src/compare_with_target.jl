function compare_with_target(
    sa_::Union{Vector{Float64},BitVector},
    fl_fe_sa::Matrix{Float64},
    fu::String,
)::Vector{Float64}

    if fu == "signal_to_noise_ratio"

        fu = InformationMetric.get_signal_to_noise_ratio

        sa_ = convert(BitVector, sa_)

    elseif fu == "pearson_correlation"

    elseif fu == "cosine_distance"

    end

    return TensorFunction.apply(sa_, fl_fe_sa, fu)

end
