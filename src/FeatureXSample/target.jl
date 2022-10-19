function error_size(nu1_, nu2_)

    if size(nu1_) != size(nu2_)

        error("Sizes mismatch.")

    end

end

function _aim(nu1_, nu2_)

    error_size(nu1_, nu2_)

    nu1_, nu2_

end

function _aim(bi_::AbstractVector{Bool}, nu_)

    error_size(bi_, nu_)

    nu_[.!bi_], nu_[bi_]

end

function _trigger(fu, nu1_, nu2_)

    fu(_aim(nu1_, nu2_)...)

end

function _get_median_difference(ve1, ve2)

    median(ve2) - median(ve1)

end

function _get_mean_difference(ve1, ve2)

    mean(ve2) - mean(ve1)

end

function target(nu_, fe_x_sa_x_nu, fu)

    if fu == "median_difference"

        fu = _get_median_difference

    elseif fu == "mean_difference"

        fu = _get_mean_difference

    elseif fu == "signal_to_noise_ratio"

        fu = OnePiece.information.get_signal_to_noise_ratio

    end

    [_trigger(fu, nu_, nu2_) for nu2_ in eachrow(fe_x_sa_x_nu)]

end
