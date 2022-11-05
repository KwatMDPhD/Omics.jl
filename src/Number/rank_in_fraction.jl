function rank_in_fraction(it)

    #
    fr = 0.0

    n = floor(Int, it / 9)

    for de in 1:n

        fr += 9.0 * 10^-de

    end

    #
    de = n + 1

    fr += convert(Float64, it % 9) * 10^-de

    #
    round(fr, digits = de)

end
