function _score_set_sakl(fe_, sc_, fe1_, bo_, fu; ex = 1.0, pl = true, ke_ar...)

    n, su, sut = _sum_all_and_true(sc_, bo_)

    suf = su - sut

    ri = 0.0

    rit = 0.0

    rif = 0.0

    le = su

    ler = sut

    lef = suf

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

        else

            rif += ab

        end

        rits = (rit / sut) + ep

        rifs = (rif / suf) + ep

        ris = (ri / su) + ep

        en = fu(rits * log(rits / ris) / 2, rifs * log(rifs / ris) / 2)

        if 1 < id

            le -= abp

            if bop

                ler -= abp

            else

                lef -= abp

            end

            lets = (ler / sut) + ep

            lefs = (lef / suf) + ep

            les = (le / su) + ep

            en -= fu(lets * log(lets / les) / 2, lefs * log(lefs / les) / 2)

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

function score_set_skl(fe_, sc_, fe1_, bo_; ex = 1.0, pl = true, ke_ar...)

    _score_set_sakl(fe_, sc_, fe1_, bo_, (tr, fa) -> tr + fa; ex = ex, pl = pl, ke_ar...)

end

function score_set_akl(fe_, sc_, fe1_, bo_; ex = 1.0, pl = true, ke_ar...)

    _score_set_sakl(fe_, sc_, fe1_, bo_, (tr, fa) -> tr - fa; ex = ex, pl = pl, ke_ar...)

end
