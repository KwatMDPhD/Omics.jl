function _sum_where_1(ve, wh_)

    su = 0

    for (id, wh) in enumerate(wh_)

        if wh == 1

            su += ve[id]

        end

    end

    su

end

function _sum_where_2(ve, wh_)

    su = 0

    for (fl, wh) in zip(ve, wh_)

        if wh == 1

            su += fl

        end

    end

    su

end

function sum_where(ve, wh_)

    if length(ve) < 3000

        _sum_where_1(ve, wh_)

    else

        _sum_where_2(ve, wh_)

    end

end
