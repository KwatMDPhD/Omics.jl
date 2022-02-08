function get_longest_common_prefix(ve_)

    le_ = [length(ve) for ve in ve_]

    mi = minimum(le_)

    ve = ve_[findfirst([le .== mi for le in le_])]

    id = 1

    while id <= mi

        va = ve[id]

        if any(ve[id] != va for ve in ve_[2:end])

            break

        end

        id += 1

    end

    if id == 1

        pr_ = nothing

    else

        pr_ = ve[1:(id-1)]

    end

    return pr_

end
