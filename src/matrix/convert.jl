function convert(ve_::Vector{Vector{T}} where {T})

    si1 = length(ve_)

    si2 = length(ve_[1])

    ma = Matrix{Float64}(undef, si1, si2)

    @inbounds @fastmath for id1 in 1:si1, id2 in 1:si2

        ma[id1, id2] = ve_[id1][id2]

    end

    ma

end
