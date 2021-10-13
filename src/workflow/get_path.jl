function get_path(se::String)::Tuple{String, String, String, String}

    if islink(se)

        se = readlink(se)

    end

    par = dirname(dirname(se))

    return par,
    joinpath(par, "input", ""),
    joinpath(par, "code", ""),
    joinpath(par, "output", "")

end

export get_path
