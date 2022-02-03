function score_set_new(
    fe_::Vector{String},
    sc_::Vector{Float64},
    fe1_::Vector{String};
    po::Float64=1.0,
    pl::Bool = true,
    ke_ar...,
)::Float64

    ab_ = abs.(sc_) ^ po

    in_ = VectorExtension.is_in(fe_, fe1_)

    ina_ = in_ .* ab_

    ou_ = 1.0 .- in_

    oua_ = ou_ .* ab_

    abp_, abpr_, abpl_ = get_probability_and_cumulate(ab_)

    inap_, inapr_, inapl_ = get_probability_and_cumulate(ina_)

    ouap_, ouapr_, ouapl_ = get_probability_and_cumulate(oua_)

    fl_ = InformationMetric.get_relative_information_difference(inapl_, ouapl_, abpl_)

    fr_ = InformationMetric.get_relative_information_difference(inapr_, ouapr_, abpr_)

    en_ = fl_ - fr_

    en = TensorExtension.get_area(en_)

    if pl

        plot_mountain(fe_, sc_, in_, en_, en; ke_ar...)

    end

    return en

end

function score_set_new(
    fe_::Vector{String},
    sc_::Vector{Float64},
    se_fe_::Dict{String,Vector{String}},
)::Dict{String,Float64}

    se_en = Dict{String,Float64}()

    for (se, fe1_) in se_fe_

        se_en[se] = score_set_new(fe_, sc_, fe1_; pl = false)

    end

    return se_en

end
