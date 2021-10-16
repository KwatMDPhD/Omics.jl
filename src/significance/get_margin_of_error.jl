using StatsBase: std

using ..math: get_confidence_interval

function get_margin_of_error(ve::Vector{Float64}; co::Float64 = 0.95)::Float64

    return get_confidence_interval(co)[2] * std(ve) / sqrt(length(ve))

end

export get_margin_of_error
