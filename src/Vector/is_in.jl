function is_in(ne_, ha_::AbstractSet)

    n = length(ne_)

    bi_ = Base.Vector{Bool}(undef, n)

    @inbounds @fastmath @simd for id in 1:n

        bi_[id] = ne_[id] in ha_

    end

    bi_

end

function is_in(ne_, ha_)

    is_in(ne_, Set(ha_))

end

function is_in(ne_id::AbstractDict, ha_)

    bi_ = fill(false, length(ne_id))

    @inbounds @fastmath @simd for ha in ha_

        id = get(ne_id, ha, nothing)

        if !isnothing(id)

            bi_[id] = true

        end

    end

    bi_

end
