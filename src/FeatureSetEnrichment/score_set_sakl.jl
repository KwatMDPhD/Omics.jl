function _score_set_sakl(fe_, sc_, fe1_, bi_, fu; ex = 1.0, pl = true, ke_ar...)

    ou_ = 1 .- bi_

    if ex == 1.0

        ab_ = abs.(sc_)

    else

        ab_ = abs.(sc_) .^ ex

    end

    ina_ = bi_ .* ab_

    oua_ = ou_ .* ab_

    abr_, abl_ = _cumulate(ab_)

    inar_, inal_ = _cumulate(ina_)

    ouar_, oual_ = _cumulate(oua_)

    en_ = fu(inal_, oual_, abl_) - fu(inar_, ouar_, abr_)

    ar = BioLab.VectorNumber.get_area(en_)

    if pl

        _plot_mountain(fe_, sc_, bi_, en_, ar; ke_ar...)

    end

    ar

end

function score_set_skl(fe_, sc_, fe1_, bi_; ex = 1.0, pl = true, ke_ar...)

    _score_set_sakl(
        fe_,
        sc_,
        fe1_,
        bi_,
        BioLab.Information.get_symmetric_kullback_leibler_divergence;
        ex = ex,
        pl = pl,
        ke_ar...,
    )

end

function score_set_akl(fe_, sc_, fe1_, bi_; ex = 1.0, pl = true, ke_ar...)

    _score_set_sakl(
        fe_,
        sc_,
        fe1_,
        bi_,
        BioLab.Information.get_antisymmetric_kullback_leibler_divergence;
        ex = ex,
        pl = pl,
        ke_ar...,
    )

end
