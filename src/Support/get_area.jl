function get_area(v::Vector{Float64})::Float64

    return sum(v) / convert(Float64, length(v))

end

export get_area
