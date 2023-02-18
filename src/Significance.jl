module Significance

using StatsBase: std

function get_margin_of_error(nu_, co = 0.95)

    return BioLab.Statistics.get_confidence_interval(co)[2] * std(nu_) / sqrt(length(nu_))

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

    nf = convert(Float64, n)

    pvs_ = [pv_[so] * nf / convert(Float64, id) for (id, so) in enumerate(so_)]

    BioLab.VectorNumber.force_increasing_with_min!(pvs_)

    return clamp!(pvs_[sortperm(so_)], 0.0, 1.0)

end

function get_p_value_and_adjust(nu_, ra_, fu)

    pv_ = [fu(nu, ra_) for nu in nu_]

    return pv_, adjust_p_value(pv_)

end

function get_p_value_and_adjust(nu_, ra_)

    lp_, la_ = get_p_value_and_adjust(nu_, ra_, get_p_value_for_less)

    rp_, ra_ = get_p_value_and_adjust(nu_, ra_, get_p_value_for_more)

    return [ifelse(lp < rp, lp, rp) for (lp, rp) in zip(lp_, rp_)],
    [ifelse(la < ra, la, ra) for (la, ra) in zip(la_, ra_)]

end

end
