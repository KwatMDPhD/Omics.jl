using ..vector: check_in
using ..vector_number: cumulate_sum_reverse, get_area
using ..information: get_relative_information_difference

function score_set_new(fe_::VS, sc_::VF, fe1_::VS; pl::Bool = true, ke_ar...)::Float64

    in_ = check_in(fe_, fe1_)

    ab_ = abs.(sc_)

    ina_ = in_ .* ab_

    ou_ = 1.0 .- in_

    abp_, abpr_, abpl_ = _get_probability_and_cumulative_probability(ab_)

    inap_, inapr_, inapl_ = _get_probability_and_cumulative_probability(ina_)

    oup_, oupr_, oupl_ = _get_probability_and_cumulative_probability(ou_)

    fl_ = get_relative_information_difference(inapl_, oupl_, abpl_)

    fr_ = get_relative_information_difference(inapr_, oupr_, abpr_)

    en_ = fl_ - fr_

    en = get_area(en_)

    if pl

        plot_mountain(fe_, sc_, in_, en_, en; ke_ar...)

    end

    return en

end

function score_set_new(fe_::VS, sc_::VF, se_fe_::DSVS)::DSF

    se_en = DSF()

    for (se, fe1_) in se_fe_

        se_en[se] = score_set_new(fe_, sc_, fe1_; pl = false)

    end

    return se_en

end

export score_set_new
