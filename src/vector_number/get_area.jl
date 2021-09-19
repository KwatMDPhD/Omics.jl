function get_area(ve::Vector{Float64})::Float64

    return sum(ve) / Float64(length(ve))

end

export get_area
