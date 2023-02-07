function _sum_ks(sc_, bo_)

    n = length(sc_)

    sut = 0.0

    suf = 0.0

    @inbounds @fastmath @simd for id in 1:n

        if bo_[id]

            sc = sc_[id]

            if sc < 0.0

                sc = -sc

            end

            sut += sc

        else

            suf += 1.0

        end

    end

    n, sut, suf

end

function _sum_kl(sc_, bo_)

    n = length(sc_)

    su = 0.0

    sut = 0.0

    @inbounds @fastmath @simd for id in 1:n

        sc = sc_[id]

        if sc < 0.0

            sc = -sc

        end

        su += sc

        if bo_[id]

            sut += sc

        end

    end

    n, su, sut

end
