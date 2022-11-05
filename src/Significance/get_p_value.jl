function get_p_value(nu, ra_, ho)

    if ho == -1

        si_ = (ra <= nu for ra in ra_)

    elseif ho == 1

        si_ = (nu <= ra for ra in ra_)

    else

        error()

    end

    n_si = sum(si_)

    n_ra = length(ra_)

    if n_si == 0

        n_si = 1

    end

    n_si / n_ra

end
