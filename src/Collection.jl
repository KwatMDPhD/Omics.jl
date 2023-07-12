module Collection

function is_in(an_id, an1_)

    is_ = falses(length(an_id))

    for an1 in an1_

        id = get(an_id, an1, nothing)

        if !isnothing(id)

            is_[id] = true

        end

    end

    is_

end

end
