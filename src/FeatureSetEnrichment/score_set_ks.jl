function score_set_ks(fe_, sc_, fe1_, bi_; ex = 1.0, pl = true, ke_ar...)

    n = length(fe_)

    cu = 0.0

    if pl

        en_ = Vector{Float64}(undef, n)

    end

    eta = 0.0

    et = 0.0

    sut, suf = _sum_1_absolute_and_0_count(sc_, bi_)

    de = 1.0 / suf

    @inbounds @fastmath @simd for id in n:-1:1

        if bi_[id]

            sc = sc_[id]

            if sc < 0.0

                sc = -sc

            end

            if ex != 1.0

                sc ^= ex

            end

            cu += sc / sut

        else

            cu -= de

        end

        if pl

            en_[id] = cu

        end

        if cu < 0.0

            ab = -cu

        else

            ab = cu

        end

        if eta < ab

            eta = ab

            et = cu

        end

    end

    if pl

        _plot_mountain(fe_, sc_, bi_, en_, et; ke_ar...)

    end

    et

end
