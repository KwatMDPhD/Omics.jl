function get_longest_common_prefix(ve_)

    le_ = [length(ve) for ve in ve_]

    mi = minimum(le_)

    sh = ve_[findfirst(le_ .== mi)]

    id = 1

    while id <= mi

        va = sh[id]

        if any(ve[id] != va for ve in ve_)

            break

        end

        id += 1

    end

    if id == 1

        nothing

    else

        sh[1:(id - 1)]

    end

end
