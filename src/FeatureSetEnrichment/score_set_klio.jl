function _score_set_klio(fe_, sc_, bo_, fu; ex = 1.0, pl = true, ke_ar...)

    n, su, su1 = _sum_all_and_1(sc_, bo_)

    su0 = su - su1

    ep = eps()

    ri = ep

    ri1 = ep

    ri0 = ep

    le = su

    le1 = su1

    le0 = su0

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

        else

            ri0 += ab

        end

        rin = ri / su

        ri1n = ri1 / su1

        ri0n = ri0 / su0

        en = fu(ri1n * log(ri1n / rin) / 2.0, ri0n * log(ri0n / rin) / 2.0)

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

            else

                le0 -= abp

                if le0 < ep

                    le0 = ep

                end

            end

            len = le / su

            le1n = le1 / su1

            le0n = le0 / su0

            en -= fu(le1n * log(le1n / len) / 2.0, le0n * log(le0n / len) / 2.0)

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

function score_set_kliop(fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    _score_set_klio(fe_, sc_, bo_, (_1, _0) -> _1 + _0; ex = ex, pl = pl, ke_ar...)

end

function score_set_kliom(fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    _score_set_klio(fe_, sc_, bo_, (_1, _0) -> _1 - _0; ex = ex, pl = pl, ke_ar...)

end
