function get_p_value_and_adjust(nu_, ra_, si)

    pv_ = [get_p_value(nu, ra_, si) for nu in nu_]

    pv_, adjust_p_value(pv_)

end

function get_p_value_and_adjust(nu_, ra_)

    lp_, la_ = get_p_value_and_adjust(nu_, ra_, -1)

    rp_, ra_ = get_p_value_and_adjust(nu_, ra_, 1)

    [ifelse(lp < rp, lp, rp) for (lp, rp) in zip(lp_, rp_)],
    [ifelse(la < ra, la, ra) for (la, ra) in zip(la_, ra_)]

end
