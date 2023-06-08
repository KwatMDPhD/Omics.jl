module Number

function rank_in_fraction(ra)

    fr = 0

    n = fld(ra, 9)

    for digits in 1:n

        fr += 9 * 10.0^-digits

    end

    digits = n + 1

    fr += (ra % 9) * 10.0^-digits

    round(fr; digits)

end

end
