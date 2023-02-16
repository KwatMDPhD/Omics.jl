module Path

function make_temporary(pa)

    pat = joinpath(tempdir(), pa)

    if ispath(pat)

        rm(pat; recursive = true)

    end

    return mkdir(pat)

end

end
