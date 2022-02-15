function get_p_value_and_adjust(fl_, ra_, si)

    pv_ = [get_p_value(fl, ra_, si) for fl in fl_]

    pv_, adjust_p_value(pv_)

end

function get_p_value_and_adjust(fl_, ra_)

    lp_, lpa_ = get_p_value_and_adjust(fl_, ra_, -1.0)

    rp_, rpa_ = get_p_value_and_adjust(fl_, ra_, 1.0)

    ifelse.(lp_ .< rp_, lp_, rp_), ifelse.(lpa_ .< rpa_, lpa_, rpa_)

end
