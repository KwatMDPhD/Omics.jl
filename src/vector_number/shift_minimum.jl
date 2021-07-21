function shift_minimum(ve::Vector{Float64}, mi::Union{Float64,String})::Vector{Float64}

    if mi == "0<"

        mi = minimum(ve[0.0 .< ve])

    end

    return mi - minimum(ve) .+ ve

end

export shift_minimum
