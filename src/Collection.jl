module Collection

using StatsBase: countmap

function error_duplicate(an_)

    if isempty(an_)

        error("Collection is empty.")

    end

    if !allunique(an_)

        st = join(("$n $an" for (an, n) in countmap(an_) if 1 < n), ". ")

        error("Collection has a duplicate. $st.")

    end

end

function error_no_change(an_)

    if allequal(an_)

        error("Collection has no change. $an_.")

    end

end

function index(an_)

    ty = eltype(an_)

    an_id = Dict{ty, Int}()

    id_an = Dict{Int, ty}()

    for (id, an) in enumerate(an_)

        an_id[an] = id

        id_an[id] = an

    end

    an_id, id_an

end

function is_in(an_, an1_)

    n = length(an_)

    bo_ = Vector{Bool}(undef, n)

    for id in 1:n

        bo_[id] = an_[id] in an1_

    end

    bo_

end

function is_in(an_id::AbstractDict, an1_)

    bo_ = fill(false, length(an_id))

    for an1 in an1_

        id = get(an_id, an1, 0)

        if !iszero(id)

            bo_[id] = true

        end

    end

    bo_

end

end
