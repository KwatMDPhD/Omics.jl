function get_common_start(an__)

    le_ = [length(an_) for an_ in an__]

    mi = minimum(le_)

    sh = an__[findfirst(==(mi), le_)]

    id = 1

    while id <= mi

        an = sh[id]

        if any(an_[id] != an for an_ in an__)

            break

        end

        id += 1

    end

    sh[1:(id - 1)]

end
