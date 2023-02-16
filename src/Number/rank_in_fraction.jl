function rank_in_fraction(it)

    fr = 0.0

    n = fld(it, 9)

    for de in 1:n

        fr += 9.0 * 10.0^-de

    end

    de = n + 1

    fr += (it % 9) * 10.0^-de

    return round(fr; digits = de)

end
