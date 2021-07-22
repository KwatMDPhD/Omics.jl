function compute_kld(ve1::Vector{Float64}, ve2::Vector{Float64})::Vector{Float64}

    return ve1 .* log.(ve1 ./ ve2)

end

export compute_kld
