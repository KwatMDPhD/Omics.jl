function check_in(st_::Vector{String}, st1_::Vector{String})::Vector{Float64}

    st1_no = Dict(st1 => nothing for st1 in st1_)

    return [Float64(haskey(st1_no, st)) for st in st_]

end

function check_in(st_ie::Dict{String,Int64}, st1_::Vector{String})::Vector{Float64}

    in_ = fill(0, length(st_ie))

    @inbounds @fastmath @simd for st1 in st1_

        ie = get(st_ie, st1, nothing)

        if ie !== nothing

            in_[ie] = 1.0

        end

    end

    return in_

end

export check_in
