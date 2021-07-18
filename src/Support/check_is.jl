function check_is(s_::Vector{String}, c_::Vector{String})::Vector{Float64}

    d = Dict(c => nothing for c in c_)

    return [Float64(haskey(d, s)) for s in s_]

end

function check_is(s_to_i::Dict{String,Int64}, c_::Vector{String})::Vector{Float64}

    is_ = fill(0, length(s_to_i))

    @inbounds @fastmath @simd for c in c_

        i = get(s_to_i, c, nothing)

        if i !== nothing

            is_[i] = 1

        end

    end

    return is_

end

export check_is
