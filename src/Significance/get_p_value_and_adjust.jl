function get_p_value_and_adjust(nu_, ra_, fu)

    pv_ = [fu(nu, ra_) for nu in nu_]

    pv_, adjust_p_value(pv_)

end

function get_p_value_and_adjust(nu_, ra_)

    lp_, la_ = get_p_value_and_adjust(nu_, ra_, get_p_value_for_less)

    rp_, ra_ = get_p_value_and_adjust(nu_, ra_, get_p_value_for_more)

    [ifelse(lp < rp, lp, rp) for (lp, rp) in zip(lp_, rp_)],
    [ifelse(la < ra, la, ra) for (la, ra) in zip(la_, ra_)]

end
