function get_p_value(fl, ra_, si)

    if si == "<"

        si_ = ra_ .<= fl

    elseif si == ">"

        si_ = fl .<= ra_

    else

        error("side is invalid.")

    end

    n_si = sum(si_)

    n_ra = length(ra_)

    if n_si == 0

        pv = 1 / n_ra

    else

        pv = n_si / n_ra

    end

    return pv

end
