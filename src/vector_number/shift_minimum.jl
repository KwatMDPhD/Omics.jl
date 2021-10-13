function shift_minimum(
    ve::Vector{Float64},
    mi::Union{Float64, String},
)::Vector{Float64}

    if isa(mi, String) && endswith(mi, '<')

        mi = minimum(ve[parse(Float64, split(mi, '<')[1]) .< ve])

    end

    return ve .+ (mi - minimum(ve))

end

export shift_minimum
