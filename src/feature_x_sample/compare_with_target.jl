function compare_with_target(sa_, an_fe_sa, fu)

    if fu == "signal_to_noise_ratio"

        fu = OnePiece.information.get_signal_to_noise_ratio

    elseif fu == "pearson_correlation"

        error()

    elseif fu == "cosine_distance"

        error()

    else

        error()

    end

    OnePiece.tensor_function.apply(sa_, an_fe_sa, fu)

end
