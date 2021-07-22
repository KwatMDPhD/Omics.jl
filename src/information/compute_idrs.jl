function compute_idrs(
    ve1::Vector{Float64},
    ve2::Vector{Float64},
    ver::Vector{Float64},
)::Vector{Float64}

    return compute_kld(ve1, ver) .+ compute_kld(ve2, ver)

end

function compute_idrs(ve1::Vector{Float64}, ve2::Vector{Float64})::Vector{Float64}

    return compute_idrs(ve1, ve2, (ve1 .+ ve2) ./ 2)

end

export compute_idrs
