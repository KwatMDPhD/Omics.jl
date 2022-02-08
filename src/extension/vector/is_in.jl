function is_in(st_::AbstractArray, st1_)

    st1_no = Dict(st1 => nothing for st1 in st1_)

    return [haskey(st1_no, st) for st in st_]

end

function is_in(st_id::AbstractDict, st1_)

    in_ = fill(0, length(st_id))

    @inbounds @fastmath @simd for st1 in st1_

        id = get(st_id, st1, nothing)

        if id !== nothing

            in_[id] = 1

        end

    end

    return in_

end
