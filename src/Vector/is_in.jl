function is_in(ne_, ha_)

    ha_ = Set(ha_)

    [ne in ha_ for ne in ne_]

end

function x(ne_, ha_)

    ha_ = Set(ha_)

    [ne in ha_ for ne in ne_]

end

function is_in(ne_id::AbstractDict, ha_)

    in_ = fill(false, length(ne_id))

    @inbounds @fastmath @simd for ha in ha_

        id = get(ne_id, ha, nothing)

        if !isnothing(id)

            in_[id] = true

        end

    end

    in_

end
