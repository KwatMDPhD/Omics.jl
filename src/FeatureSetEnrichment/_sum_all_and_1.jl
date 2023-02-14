function _sum_all_and_1(sc_, bo_, ex)

    n = length(sc_)

    su = 0.0

    su1 = 0.0

    # TODO: Speed up.
    for id in 1:n

        abe = _get_absolute_raise(sc_, id, ex)

        su += abe

        if bo_[id]

            su1 += abe

        end

    end

    n, su, su1

end
