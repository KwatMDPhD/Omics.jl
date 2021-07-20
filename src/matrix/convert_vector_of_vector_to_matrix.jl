function convert_vector_of_vector_to_matrix(vv::Vector{Vector{Float64}})::Matrix{Float64}

    d1 = length(vv)

    d2 = length(vv[1])

    m = Matrix{Float64}(undef, d1, d2)

    @inbounds @fastmath for i = 1:d1, j = 1:d2

        m[i, j] = vv[i][j]

    end

    return m

end

export convert_vector_of_vector_to_matrix
