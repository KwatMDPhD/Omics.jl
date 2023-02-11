function score_set_kli(fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    n, su, su1 = _sum_all_and_1(sc_, bo_)

    ep = eps()

    ri = ep

    ri1 = ep

    le = su

    le1 = su1

    abp = 0.0

    bop = false

    if pl

        en_ = Vector{Float64}(undef, n)

    end

    ar = 0.0

    @inbounds @fastmath @simd for id in 1:n

        ab = _get_1(sc_, id, ex)

        ri += ab

        bo = bo_[id]

        if bo

            ri1 += ab

        end

        ri1n = ri1 / su1

        en = ri1n * log(ri1n / (ri / su))

        if 1 < id

            le -= abp

            if le < ep

                le = ep

            end

            if bop

                le1 -= abp

                if le1 < ep

                    le1 = ep

                end

            end

            le1n = le1 / su1

            en -= le1n * log(le1n / (le / su))

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
