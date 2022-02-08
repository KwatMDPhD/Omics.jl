function get_p_value_and_adjust(
    fl_,
    ra_,
    di,
)

    pv_ = [get_p_value(fl, ra_, di) for fl in fl_]

    return pv_, adjust_p_value(pv_)

end

function get_p_value_and_adjust(
    fl_,
    ra_,
)

    lp_, lpa_ = get_p_value_and_adjust(fl_, ra_, "<")

    rp_, rpa_ = get_p_value_and_adjust(fl_, ra_, ">")

    return ifelse.(lp_ .< rp_, lp_, rp_), ifelse.(lpa_ .< rpa_, lpa_, rpa_)

end
