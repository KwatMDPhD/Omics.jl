function score_set_kli(fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    n, su, su1 = _sum_all_and_1(sc_, bo_, ex)

    ep = eps()

    ri = ep

    ri1 = ep

    le = su

    le1 = su1

    pra = 0.0

    prb = false

    if pl

        en_ = Vector{Float64}(undef, n)

    end

    ar = 0.0

    for id in 1:n

        abe = _get_absolute_raise(sc_, id, ex)

        ri += abe

        bo = bo_[id]

        if bo

            ri1 += abe

        end

        rin = ri / su

        ri1n = ri1 / su1

        le = _clip(le, pra, ep)

        if prb

            le1 = _clip(le1, pra, ep)

        end

        len = le / su

        le1n = le1 / su1

        en = ri1n * log(ri1n / rin) - le1n * log(le1n / len)

        pra = abe

        prb = bo

        if pl

            en_[id] = en

        end

        ar += en

    end

    ar /= n

    if pl

        _plot_mountain(fe_, sc_, bo_, en_, ar; ke_ar...)

    end

    return ar

end
