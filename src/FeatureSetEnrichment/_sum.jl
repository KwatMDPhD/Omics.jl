function _sum_1_and_0(sc_, bo_)

    n = length(sc_)

    su1 = 0.0

    su0 = 0.0

    @inbounds @fastmath @simd for id in 1:n

        if bo_[id]

            ab = sc_[id]

            if ab < 0.0

                ab = -ab

            end

            su1 += ab

        else

            su0 += 1.0

        end

    end

    n, su1, su0

end

function _sum_all_and_1(sc_, bo_)

    n = length(sc_)

    su = 0.0

    su1 = 0.0

    @inbounds @fastmath @simd for id in 1:n

        ab = sc_[id]

        if ab < 0.0

            ab = -ab

        end

        su += ab

        if bo_[id]

            su1 += ab

        end

    end

    n, su, su1

end
