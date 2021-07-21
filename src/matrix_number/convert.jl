function convert(ve::Vector{Vector{Float64}})::Matrix{Float64}

    di1 = length(ve)

    di2 = length(ve[1])

    ma = Matrix{Float64}(undef, di1, di2)

    @inbounds @fastmath for ie1 = 1:di1, ie2 = 1:di2

        ma[ie1, ie2] = ve[ie1][ie2]

    end

    return ma

end

export convert
