function get_p_value(nu, ra_, si)

    if si == -1

        si_ = [ra <= nu for ra in ra_]

    elseif si == 1

        si_ = [nu <= ra for ra in ra_]

    end

    n_si = sum(si_)

    n_ra = length(ra_)

    if n_si == 0

        n_si = 1

    end

    n_si / n_ra

end
