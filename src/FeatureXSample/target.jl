function _aim(nu1_, nu2_)

    OnePiece.Array.error_size((nu1_, nu2_))

    nu1_, nu2_

end

function _aim(bi_::AbstractVector, nu_)

    OnePiece.Array.error_size((bi_, nu_))

    nu_[[!bi for bi in bi_]], nu_[bi_]

end

function _trigger(fu, nu1_, nu2_)

    fu(_aim(nu1_, nu2_)...)

end

function target(nu_, fe_x_sa_x_nu, fu)

    if fu == "median_difference"

        fu = (ve1, ve2) -> median(ve2) - median(ve1)

    elseif fu == "mean_difference"

        fu = (ve1, ve2) -> mean(ve2) - mean(ve1)

    elseif fu == "signal_to_noise_ratio"

        fu = OnePiece.information.get_signal_to_noise_ratio

    end

    [_trigger(fu, nu_, nu2_) for nu2_ in eachrow(fe_x_sa_x_nu)]

end
