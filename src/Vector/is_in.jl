function is_in(ne_, ha_)

    map(in(ha_), ne_)

end

function is_in(ne_id::AbstractDict, ha_)

    bo_ = fill(false, length(ne_id))

    @inbounds @fastmath @simd for ha in ha_

        id = get(ne_id, ha, nothing)

        if !isnothing(id)

            bo_[id] = true

        end

    end

    bo_

end
