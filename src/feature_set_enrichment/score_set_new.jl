function score_set_new(fe_, sc_, fe1_; ex = 1.0, pl = true, ke_ar...)

    #
    in_ = convert(Vector{Float64}, OnePiece.vector.is_in(fe_, fe1_))

    ou_ = 1.0 .- in_

    #
    ab_ = abs.(sc_) .^ ex

    ina_ = in_ .* ab_

    oua_ = ou_ .* ab_

    #
    abp_, abpr_, abpl_ = _get_probability_and_cumulate(ab_)

    inap_, inapr_, inapl_ = _get_probability_and_cumulate(ina_)

    ouap_, ouapr_, ouapl_ = _get_probability_and_cumulate(oua_)

    #oup_, oupr_, oupl_ = _get_probability_and_cumulate(ou_)

    fl_ = OnePiece.information.get_kwat_pablo_divergence(inapl_, ouapl_, abpl_)

    fr_ = OnePiece.information.get_kwat_pablo_divergence(inapr_, ouapr_, abpr_)

    en_ = fl_ - fr_

    en = OnePiece.tensor.get_area(en_)

    if pl

        _plot_mountain(fe_, sc_, in_, en_, en; ke_ar...)

    end

    en

end

function score_set_new(fe_, sc_, se_fe_::Dict; ex = 1.0, n_jo = 1)

    Dict(se => score_set_new(fe_, sc_, fe1_, ex = ex, pl = false) for (se, fe1_) in se_fe_)

end
