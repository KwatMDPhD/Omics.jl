function is_in(ne_, ha_)

    n = length(ne_)

    bo_ = Base.Vector{Bool}(undef, n)

    @inbounds @simd for id in 1:n

        bo_[id] = ne_[id] in ha_

    end

    bo_

end

function is_in(ne_id::AbstractDict, ha_)

    bo_ = fill(false, length(ne_id))

    @inbounds @simd for ha in ha_

        id = get(ne_id, ha, nothing)

        if !isnothing(id)

            bo_[id] = true

        end

    end

    bo_

end
