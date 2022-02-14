function get_p_value(fl, ra_, si)

    if isempty(ra_)

        error("randoms are empty and cannot be used to compute significance.")

    end

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

        1 / n_ra

    else

        n_si / n_ra

    end

end
