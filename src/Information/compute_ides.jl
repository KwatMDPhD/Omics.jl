function compute_ides(v1::Vector{Float64}, v2::Vector{Float64})::Vector{Float64}

    return compute_kld(v1, v2) .+ compute_kld(v2, v1)

end

export compute_ides
