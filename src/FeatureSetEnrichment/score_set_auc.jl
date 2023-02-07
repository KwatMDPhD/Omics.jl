function score_set_auc(fe_, sc_, fe1_, bi_; ex = 1.0, pl = true, ke_ar...)

    n, sut, suf = _sum_ks(sc_, bi_)

    cu = 0.0

    de = 1.0 / suf

    if pl

        en_ = Vector{Float64}(undef, n)

    end

    ar = 0.0

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

        ar += cu

    end

    ar /= n

    if pl

        _plot_mountain(fe_, sc_, bi_, en_, ar; ke_ar...)

    end

    ar

end
