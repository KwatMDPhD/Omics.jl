function _aim(nu1_, nu2_)

    BioLab.Array.error_size((nu1_, nu2_))

    nu1_, nu2_

end

function _aim(bo_::AbstractVector{Bool}, nu_)

    BioLab.Array.error_size((bo_, nu_))

    nu_[[!bo for bo in bo_]], nu_[bo_]

end

function _trigger(fu, nu1_, nu2_)

    fu(_aim(nu1_, nu2_)...)

end

function _get_mean_difference(ve1, ve2)

    mean(ve1) - mean(ve2)

end

function _get_median_difference(ve1, ve2)

    median(ve1) - median(ve2)

end

function target(nu_, fe_x_sa_x_nu, na)

    fu = Dict(
        "mean_difference" => _get_mean_difference,
        "median_difference" => _get_median_difference,
        "signal_to_noise_ratio" => BioLab.Information.get_signal_to_noise_ratio,
    )[na]

    [_trigger(fu, nu_, nu2_) for nu2_ in eachrow(fe_x_sa_x_nu)]

end
