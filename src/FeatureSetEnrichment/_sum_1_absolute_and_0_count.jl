function _sum_1_absolute_and_0_count(sc_, bi_)

    sut = 0.0

    suf = 0.0

    @inbounds @fastmath @simd for id in 1:length(sc_)

        if bi_[id]

            sc = sc_[id]

            if sc < 0.0

                sc = -sc

            end

            sut += sc

        else

            suf += 1.0

        end

    end

    sut, suf

end
