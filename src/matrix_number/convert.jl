Ty = Matrix{Float64}

function convert(ve_::Vector{Vector{Float64}})::Ty

    si1 = length(ve_)

    si2 = length(ve_[1])

    ma = Ty(undef, si1, si2)

    @inbounds @fastmath for ie1 = 1:si1, ie2 = 1:si2

        ma[ie1, ie2] = ve_[ie1][ie2]

    end

    return ma

end

export convert
