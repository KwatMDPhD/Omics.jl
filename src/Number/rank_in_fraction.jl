function rank_in_fraction(it)

    fr = 0

    fl = floor(it / 9)

    for de in 1:fl

        fr += 9 * 10^-de

    end

    de = fl + 1.0

    fr += (it % 9) * 10^-de

    #
    round(fr, digits = convert(Int, de))

end
