function get_relative_information_difference(
    ve1::Vector{Float64},
    ve2::Vector{Float64},
    ver::Vector{Float64},
)::Vector{Float64}

    return get_kld(ve1, ver) .- get_kld(ve2, ver)

end

function get_relative_information_difference(ve1::Vector{Float64}, ve2::Vector{Float64})::Vector{Float64}

    return get_idrd(ve1, ve2, (ve1 .+ ve2) ./ 2)

end

export get_relative_information_difference
