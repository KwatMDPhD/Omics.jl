function convert(
    an::Union{Vector{T},UnitRange{T},StepRange{T}} where {T<:Real},
)::Vector{Float64}

    return Base.convert(Vector{Float64}, an)

end

function convert(ve_::Vector{Vector{T}} where {T<:Real})::Matrix{Float64}

    si1 = length(ve_)

    si2 = length(ve_[1])

    ma = Matrix{Float64}(undef, si1, si2)

    @inbounds @fastmath for id1 = 1:si1, id2 = 1:si2

        ma[id1, id2] = ve_[id1][id2]

    end

    return ma

end
