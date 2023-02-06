function score_set_kl(fe_, sc_, fe1_, bi_; ex = 1.0, pl = true, ke_ar...)

    ab_ = abs.(sc_)

    if ex != 1.0

        ab_ .^= ex

    end

    ina_ = bi_ .* ab_

    abr_, abl_ = _cumulate(ab_)

    inar_, inal_ = _cumulate(ina_)

    ep = eps()

    en_ =
        BioLab.Information.get_kullback_leibler_divergence(inal_ .+ ep, abl_ .+ ep) -
        BioLab.Information.get_kullback_leibler_divergence(inar_ .+ ep, abr_ .+ ep)

    ar = BioLab.VectorNumber.get_area(en_)

    if pl

        _plot_mountain(fe_, sc_, bi_, en_, ar; ke_ar...)

    end

    ar

end
