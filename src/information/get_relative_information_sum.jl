# Jensen-Shannon divergence
function get_relative_information_sum(
    ve1::Vector{Float64},
    ve2::Vector{Float64},
    ver::Vector{Float64},
    we1::Real=0.5,
    we2::Real=0.5,
)::Vector{Float64}

    return get_kullback_leibler_divergence(ve1, ver) .* we1 .+
           get_kullback_leibler_divergence(ve2, ver) .* we2

end

function get_relative_information_sum(
    ve1::Vector{Float64},
    ve2::Vector{Float64},
)::Vector{Float64}

    return get_relative_information_sum(ve1, ve2, (ve1 .+ ve2) ./ 2)

end
