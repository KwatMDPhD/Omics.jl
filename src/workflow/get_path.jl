function get_path(se::String)::Tuple{String, String, String, String}

    if islink(se)

        se = readlink(se)

    end

    pai = dirname(se)

    if splitdir(pai)[2] != "input"

        error("setting is not in input.")

    end

    par = string(dirname(pai), "/")

    return par,
    joinpath(par, "input", ""),
    joinpath(par, "code", ""),
    joinpath(par, "output", "")

end

export get_path
