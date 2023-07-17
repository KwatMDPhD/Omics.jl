module Collection

function is_in(an_id, an1_)

    bi_ = falses(length(an_id))

    for an1 in an1_

        id = get(an_id, an1, nothing)

        if !isnothing(id)

            bi_[id] = true

        end

    end

    bi_

end

end
