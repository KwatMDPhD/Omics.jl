function apply(bi_::BitVector, ve::Vector{Float64}, fu::Function)::Any

    return fu(ve[bi_], ve[.!bi_])

end

function apply(
    ve::Vector{Float64},
    ma::Matrix{Float64},
    fu::Function,
)::Vector{Any}

    return [fu(ve, ro) for ro in eachrow(ma)]

end

function apply(bi_::BitVector, ma::Matrix{Float64}, fu::Function)::Vector{Any}

    return [apply(bi_, convert(Vector{Float64}, ro), fu) for ro in eachrow(ma)]

end

function apply(
    ma1::Matrix{Float64},
    ma2::Matrix{Float64},
    fu::Function,
)::Matrix{Any}

    return [fu(ro1, ro2) for ro1 in eachrow(ma1), ro2 in eachrow(ma2)]

end

export apply
