function get_longest_common_prefix(ve_::Vector{Vector{T}})::Vector{T} where {T}

    le_ = [length(ve) for ve in ve_]

    mi = minimum(le_)

    ve = ve_[findfirst(isequal(mi), le_)]

    id = 1

    while id <= mi

        va = ve[id]

        if any(ve -> ve[id] != va, ve_[2:end])

            break

        end

        id += 1

    end

    if id == 1

        pr_ = Vector{T}()

    elseif id < mi

        pr_ = ve[1:(id - 1)]

    else

        pr_ = ve

    end

    return pr_

end

export get_longest_common_prefix
