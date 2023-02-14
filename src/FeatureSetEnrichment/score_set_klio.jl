function _score_set_klio(fe_, sc_, bo_, fu; ex = 1.0, pl = true, ke_ar...)

    n, su, su1 = _sum_all_and_1(sc_, bo_, ex)

    su0 = su - su1

    ep = eps()

    ri = ep

    ri1 = ep

    ri0 = ep

    le = su

    le1 = su1

    le0 = su0

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

        else

            ri0 += abe

        end

        rin = ri / su

        ri1n = ri1 / su1

        ri0n = ri0 / su0

        le = _clip(le, pra, ep)

        if prb

            le1 = _clip(le1, pra, ep)

        else

            le0 = _clip(le0, pra, ep)

        end

        len = le / su

        le1n = le1 / su1

        le0n = le0 / su0

        en =
            fu(ri1n * log(ri1n / rin), ri0n * log(ri0n / rin)) -
            fu(le1n * log(le1n / len), le0n * log(le0n / len))

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

    ar

end

function score_set_kliop(fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    _score_set_klio(fe_, sc_, bo_, (_1, _0) -> _1 + _0; ex = ex, pl = pl, ke_ar...)

end

function score_set_kliom(fe_, sc_, bo_; ex = 1.0, pl = true, ke_ar...)

    _score_set_klio(fe_, sc_, bo_, (_1, _0) -> _1 - _0; ex = ex, pl = pl, ke_ar...)

end
