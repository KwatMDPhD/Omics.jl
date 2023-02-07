function score_set_kl(fe_, sc_, fe1_, bo_; ex = 1.0, pl = true, ke_ar...)

    n, su, sut = _sum_all_and_true(sc_, bo_)

    ri = 0.0

    rit = 0.0

    le = su

    ler = sut

    ep = eps()

    abp = 0.0

    bop = false

    if pl

        en_ = Vector{Float64}(undef, n)

    end

    ar = 0.0

    @inbounds @fastmath @simd for id in 1:n

        ab = sc_[id]

        if ab < 0.0

            ab = -ab

        end

        if ex != 1.0

            ab ^= ex

        end

        ri += ab

        bo = bo_[id]

        if bo

            rit += ab

        end

        rits = (rit / sut) + ep

        en = rits * log(rits / ((ri / su) + ep))

        if 1 < id

            le -= abp

            if bop

                ler -= abp

            end

            lets = (ler / sut) + ep

            en -= lets * log(lets / ((le / su) + ep))

        end

        abp = ab

        bop = bo

        if pl

            en_[id] = en

        end

        ar += en

    end

    ar /= n

    if pl

        _plot_mountain(fe_, sc_, bo_, en_, ar; ke_ar...)

    end

    ar

end
