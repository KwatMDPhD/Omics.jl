function score_set_new(fe_, sc_, fe1_::AbstractVector; ex = 1.0, pl = true, ke_ar...)

    #
    in_ = convert(Vector{Float64}, OnePiece.Vector.is_in(fe_, fe1_))

    ou_ = [1.0 - i for i in in_]

    #
    ab_ = [abs(sc)^ex for sc in sc_]

    #
    ina_ = [i * ab for (i, ab) in zip(in_, ab_)]

    oua_ = [ou * ab for (ou, ab) in zip(ou_, ab_)]

    #
    abr_, abl_ = _cumulate(ab_)

    inar_, inal_ = _cumulate(ina_)

    ouar_, oual_ = _cumulate(oua_)

    #
    en_ =
        OnePiece.Information.get_antisymmetric_kullback_leibler_divergence(inal_, oual_, abl_) -
        OnePiece.Information.get_antisymmetric_kullback_leibler_divergence(inar_, ouar_, abr_)

    #
    et = OnePiece.VectorNumber.get_extreme(en_)

    ar = OnePiece.VectorNumber.get_area(en_)

    #
    if pl

        _plot_mountain(fe_, sc_, in_, en_, et, ar; ke_ar...)

    end

    #
    et, ar

end

function score_set_new(fe_, sc_, se_fe1_; ex = 1.0, n_jo = 1)

    Dict(se => score_set_new(fe_, sc_, fe1_, ex = ex, pl = false) for (se, fe1_) in se_fe1_)

end
