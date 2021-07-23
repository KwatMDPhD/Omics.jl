function get_ides(ve1::Vector{Float64}, ve2::Vector{Float64})::Vector{Float64}

    return get_kld(ve1, ve2) .+ get_kld(ve2, ve1)

end

export get_ides
