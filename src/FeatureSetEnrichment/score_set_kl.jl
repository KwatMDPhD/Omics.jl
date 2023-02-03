function score_set_kl(fe_, sc_, fe1_, bi_; ex = 1.0, pl = true, ke_ar...)

    if ex == 1.0

        ab_ = abs.(sc_)

    else

        ab_ = abs.(sc_) .^ ex

    end

    ina_ = bi_ .* ab_

    abr_, abl_ = _cumulate(ab_)

    inar_, inal_ = _cumulate(ina_)

    en_ =
        BioLab.Information.get_kullback_leibler_divergence(inal_, abl_) -
        BioLab.Information.get_kullback_leibler_divergence(inar_, abr_)

    ar = BioLab.VectorNumber.get_area(en_)

    if pl

        _plot_mountain(fe_, sc_, bi_, en_, ar; ke_ar...)

    end

    ar

end
