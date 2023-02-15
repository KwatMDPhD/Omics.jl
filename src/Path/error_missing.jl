function error_missing(di, pa_)

    for pa in pa_

        paj = joinpath(di, pa)

        if !ispath(paj)

            error(paj)

        end

    end

    return nothing

end
