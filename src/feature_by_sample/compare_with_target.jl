function compare_with_target(
    sa_::BitVector,
    an_fe_sa,
    fu,
)

    if fu == "signal_to_noise_ratio"

        fu = get_signal_to_noise_ratio

    end

    return apply(sa_, an_fe_sa, fu)

end

function compare_with_target(
    sa_,
    an_fe_sa,
    fu,
)

    if fu == "pearson_correlation"

        fu = fu

    elseif fu == "cosine_distance"

        fu = fu

    end

    return apply(sa_, an_fe_sa, fu)

end
