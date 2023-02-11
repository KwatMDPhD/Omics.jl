function _sum_1_and_0(sc_, bo_, ex)

    n = length(sc_)

    su1 = 0.0

    su0 = 0.0

    @inbounds @fastmath @simd for id in 1:n

        if bo_[id]

            su1 += _get_1(sc_, id, ex)

        else

            su0 += 1.0

        end

    end

    n, su1, su0

end

function _sum_all_and_1(sc_, bo_, ex)

    n = length(sc_)

    su = 0.0

    su1 = 0.0

    @inbounds @fastmath @simd for id in 1:n

        ab = _get_1(sc_, id, ex)

        su += ab

        if bo_[id]

            su1 += ab

        end

    end

    n, su, su1

end
