function _median_difference(ve1, ve2)

    median(ve1) - median(ve2)

end

function _mean_difference(ve1, ve2)

    mean(ve1) - mean(ve2)

end

function compare_with_target(sa_, an_fe_sa, fu)

    if fu == "median_difference"

        fu = _median_difference

    elseif fu == "mean_difference"

        fu = _mean_difference

    elseif fu == "signal_to_noise_ratio"

        fu = OnePiece.information.get_signal_to_noise_ratio

    end

    OnePiece.tensor_function.apply(sa_, an_fe_sa, fu)

end
