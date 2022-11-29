function score_set_new(fe_, sc_, fe1_::AbstractVector; ex = 1.0, pl = true, ke_ar...)

    #
    bi_ = BioLab.Vector.is_in(fe_, fe1_)

    ou_ = (1 - bi for bi in bi_)

    #
    ab_ = [abs(sc)^ex for sc in sc_]

    #
    ina_ = [bi * ab for (bi, ab) in zip(bi_, ab_)]

    oua_ = [ou * ab for (ou, ab) in zip(ou_, ab_)]

    #
    abr_, abl_ = _cumulate(ab_)

    inar_, inal_ = _cumulate(ina_)

    ouar_, oual_ = _cumulate(oua_)

    #
    en_ =
        BioLab.Information.get_antisymmetric_kullback_leibler_divergence(inal_, oual_, abl_) -
        BioLab.Information.get_antisymmetric_kullback_leibler_divergence(inar_, ouar_, abr_)

    #
    et = BioLab.VectorNumber.get_extreme(en_)

    ar = BioLab.VectorNumber.get_area(en_)

    #
    if pl

        _plot_mountain(fe_, sc_, bi_, en_, et, ar; ke_ar...)

    end

    #
    et, ar

end

function score_set_new(fe_, sc_, se_fe_; ex = 1.0)

    Dict(se => score_set_new(fe_, sc_, fe1_, ex = ex, pl = false) for (se, fe1_) in se_fe_)

end
