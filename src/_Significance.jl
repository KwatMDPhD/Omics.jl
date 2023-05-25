module Significance

using StatsBase: std

using ..BioLab

function get_margin_of_error(nu_, er = 0.05)

    return BioLab.Statistics.get_z_score(1.0 - er / 2.0) * std(nu_) / sqrt(length(nu_))

end

function _get_p_value(n, ra_)

    if n == 0

        n = 1

    end

    return n / length(ra_)

end

function get_p_value_for_less(nu, ra_)

    return _get_p_value(sum((ra <= nu for ra in ra_)), ra_)

end

function get_p_value_for_more(nu, ra_)

    return _get_p_value(sum((nu <= ra for ra in ra_)), ra_)

end

function adjust_p_value_with_bonferroni(pv_, n = length(pv_))

    return clamp!(pv_ * n, 0.0, 1.0)

end

function adjust_p_value_with_benjamini_hochberg(pv_, n = length(pv_))

    so_ = sortperm(pv_)

    pvs_ = [pv_[so] * n / id for (id, so) in enumerate(so_)]

    BioLab.VectorNumber.force_increasing_with_min!(pvs_)

    return clamp!(pvs_[sortperm(so_)], 0.0, 1.0)

end

function get_p_value_and_adjust(fu, nu_, ra_)

    pv_ = [fu(nu, ra_) for nu in nu_]

    return pv_, adjust_p_value_with_benjamini_hochberg(pv_)

end

function get_p_value_and_adjust(nu_, ra_)

    pvl_, adl_ = get_p_value_and_adjust(get_p_value_for_less, nu_, ra_)

    pvm_, adm_ = get_p_value_and_adjust(get_p_value_for_more, nu_, ra_)

    return [ifelse(pvl < pvm, pvl, pvm) for (pvl, pvm) in zip(pvl_, pvm_)],
    [ifelse(adl < adm, adl, adm) for (adl, adm) in zip(adl_, adm_)]

end

end
