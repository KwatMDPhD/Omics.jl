function score_set_kl(fe_, sc_, fe1_, bi_; ex = 1.0, pl = true, ke_ar...)

    su, sub, n = _xxx(sc_, bi_)

    ep = eps()

    nu = sc_[1]

    if nu < 0.0

        nu = -nu

    end

    ri = nu

    rib = 0.0

    if bi_[1]

        rib += nu

    end

    ribs = (rib / sub) + ep

    le = su

    leb = sub

    lebs = (leb / sub) + ep

    en = lebs * log(lebs / ((le / su) + ep)) - ribs * log(ribs / ((ri / su) + ep))

    if pl

        en_ = Vector{Float64}(undef, n)

        en_[1] = en

    end

    ar = en

    @inbounds @fastmath @simd for id in 1:(n - 1)

        idn = id + 1

        nun = sc_[idn]

        if nun < 0.0

            nun = -nun

        end

        ri += nun

        if bi_[idn]

            rib += nun

        end

        ribs = (rib / sub) + ep

        nu = sc_[id]

        if nu < 0.0

            nu = -nu

        end

        le -= nu

        if bi_[id]

            leb -= nu

        end

        lebs = (leb / sub) + ep

        en = lebs * log(lebs / ((le / su) + ep)) - ribs * log(ribs / ((ri / su) + ep))

        if pl

            en_[idn] = en

        end

        ar += en

    end

    ar /= n

    if pl

        _plot_mountain(fe_, sc_, bi_, en_, ar; ke_ar...)

    end

    ar

end
