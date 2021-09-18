function get_symmetric_information_sum(ve1::Vector{Float64}, ve2::Vector{Float64})::Vector{Float64}

    return get_kld(ve1, ve2) .+ get_kld(ve2, ve1)

end

export get_symmetric_information_sum
