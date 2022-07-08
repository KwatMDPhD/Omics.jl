function make_temporary(na)

    te = joinpath(tempdir(), na)

    if isdir(te)

        rm(te, recursive = true)

    end

    mkdir(te)

end
