function compute_kld(v1::Vector{Float64}, v2::Vector{Float64})::Vector{Float64}

    return v1 .* log.(v1 ./ v2)

end

export compute_kld
