function get_common_start(ve_)

    le_ = [length(ve) for ve in ve_]

    mi = minimum(le_)

    sh = ve_[findfirst(le == mi for le in le_)]

    id = 1

    while id <= mi

        va = sh[id]

        if any(ve[id] != va for ve in ve_)

            break

        end

        id += 1

    end

    sh[1:(id - 1)]

end
