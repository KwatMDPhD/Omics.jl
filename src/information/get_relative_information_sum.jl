function get_relative_information_sum(
    ve1::Vector{Float64},
    ve2::Vector{Float64},
    ver::Vector{Float64},
)::Vector{Float64}

    return get_kullback_leibler_divergence(ve1, ver) .+
           get_kullback_leibler_divergence(ve2, ver)

end

function get_relative_information_sum(
    ve1::Vector{Float64},
    ve2::Vector{Float64},
)::Vector{Float64}

    return get_relative_information_sum(ve1, ve2, (ve1 .+ ve2) ./ 2)

end

export get_relative_information_sum
