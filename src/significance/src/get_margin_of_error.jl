function get_margin_of_error(ve::Vector{Float64}; co::Float64 = 0.95)::Float64

    return StatisticsExtension.get_confidence_interval(co)[2] * StatsBase.std(ve) /
           sqrt(length(ve))

end
