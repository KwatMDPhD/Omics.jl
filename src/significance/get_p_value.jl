function get_p_value(nu, ra_, si)

    if isempty(ra_)

        error("there is not enough randoms ($(length(ra_)) to compute significance.")

    end

    if si == -1.0

        si_ = ra_ .<= nu

    elseif si == 1.0

        si_ = nu .<= ra_

    else

        error()

    end

    n_si = sum(si_)

    n_ra = length(ra_)

    if n_si == 0

        1 / n_ra

    else

        n_si / n_ra

    end

end
