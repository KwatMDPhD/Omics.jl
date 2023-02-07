function _cumulate(ab_)

    n = length(ab_)

    su = sum(ab_)

    ri_ = Vector{Float64}(undef, n)

    le_ = Vector{Float64}(undef, n)

    ri_[1] = ab_[1]

    le_[1] = su

    @inbounds @fastmath @simd for id in 1:(n - 1)

        idn = id + 1

        ri_[idn] = ri_[id] + ab_[idn]

        le_[idn] = le_[id] - ab_[id]

    end

    ri_ / su, le_ / su

end

# TODO: Speed up.
function _score_set_sakl(fe_, sc_, fe1_, bo_, fu; ex = 1.0, pl = true, ke_ar...)

    ou_ = 1 .- bo_

    if ex == 1.0

        ab_ = abs.(sc_)

    else

        ab_ = abs.(sc_) .^ ex

    end

    ina_ = bo_ .* ab_

    oua_ = ou_ .* ab_

    abr_, abl_ = _cumulate(ab_)

    inar_, inal_ = _cumulate(ina_)

    ouar_, oual_ = _cumulate(oua_)

    en_ = fu(inal_, oual_, abl_) - fu(inar_, ouar_, abr_)

    ar = BioLab.VectorNumber.get_area(en_)

    if pl

        _plot_mountain(fe_, sc_, bo_, en_, ar; ke_ar...)

    end

    ar

end

function score_set_skl(fe_, sc_, fe1_, bo_; ex = 1.0, pl = true, ke_ar...)

    _score_set_sakl(
        fe_,
        sc_,
        fe1_,
        bo_,
        BioLab.Information.get_symmetric_kullback_leibler_divergence;
        ex = ex,
        pl = pl,
        ke_ar...,
    )

end

function score_set_akl(fe_, sc_, fe1_, bo_; ex = 1.0, pl = true, ke_ar...)

    _score_set_sakl(
        fe_,
        sc_,
        fe1_,
        bo_,
        BioLab.Information.get_antisymmetric_kullback_leibler_divergence;
        ex = ex,
        pl = pl,
        ke_ar...,
    )

end
