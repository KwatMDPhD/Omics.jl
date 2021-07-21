function compute_ides(ve1::Vector{Float64}, ve2::Vector{Float64})::Vector{Float64}

    return compute_kld(ve1, ve2) .+ compute_kld(ve2, ve1)

end

export compute_ides
