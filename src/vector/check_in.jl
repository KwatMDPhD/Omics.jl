function check_in(st_::Vector{String}, st1_::Vector{String})::Vector{Float64}

    st1_no = Dict(st1 => nothing for st1 in st1_)

    return [Float64(haskey(st1_no, st)) for st in st_]

end

function check_in(
    st_id::Dict{String, Int64},
    st1_::Vector{String},
)::Vector{Float64}

    in_ = fill(0, length(st_id))

    @inbounds @fastmath @simd for st1 in st1_

        id = get(st_id, st1, nothing)

        if id !== nothing

            in_[id] = 1.0

        end

    end

    return in_

end

export check_in
