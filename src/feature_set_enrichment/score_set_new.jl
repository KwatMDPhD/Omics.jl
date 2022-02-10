function score_set_new(fe_, sc_, fe1_; we = 1.0, pl = true, ke_ar...)

    #
    in_ = convert(Vector{Float64}, is_in(fe_, fe1_))

    ou_ = 1.0 .- in_

    #
    ab_ = abs.(sc_) .^ we

    ina_ = in_ .* ab_

    oua_ = ou_ .* ab_

    #
    abp_, abpr_, abpl_ = get_probability_and_cumulate(ab_)

    inap_, inapr_, inapl_ = get_probability_and_cumulate(ina_)

    ouap_, ouapr_, ouapl_ = get_probability_and_cumulate(oua_)

    #oup_, oupr_, oupl_ = get_probability_and_cumulate(ou_)

    fl_ = get_kwat_pablo_divergence(inapl_, ouapl_, abpl_)

    fr_ = get_kwat_pablo_divergence(inapr_, ouapr_, abpr_)

    en_ = fl_ - fr_

    en = get_area(en_)

    if pl

        display(plot_mountain(fe_, sc_, in_, en_, en; ke_ar...))

    end

    return en

end

function score_set_new(fe_, sc_, se_fe_::Dict; we = 1.0)

    return Dict(se => score_set_new(fe_, sc_, fe1_, we = we, pl = false) for (se, fe1_) in se_fe_)

end
