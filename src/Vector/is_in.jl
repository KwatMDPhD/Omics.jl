# TODO: Use Set
function is_in(st_, st1_)

    st1_no = Dict(st1 => nothing for st1 in st1_)

    [haskey(st1_no, st) for st in st_]

end

function is_in(st_id::AbstractDict, st1_)

    in_ = fill(false, length(st_id))

    @inbounds @fastmath @simd for st1 in st1_

        id = get(st_id, st1, nothing)

        if id !== nothing

            in_[id] = true

        end

    end

    in_

end
