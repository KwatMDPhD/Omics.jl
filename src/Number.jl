module Number

function rank_in_fraction(ra)

    fr = 0

    n = fld(ra, 9)

    for id in 1:n

        fr += 9 * 10.0^-id

    end

    id = n + 1

    fr += (ra % 9) * 10.0^-id

    round(fr; digits = id)

end

end
