function get_path(se::String)::Tuple{String, String, String, String}

    if islink(se)

        se = readlink(se)

    end

    pai = dirname(se)

    ip = "input"

    if splitdir(pai)[2] != ip

        error("setting is not in ",ip,".")

    end

    par = dirname(pai)

    par = "$par/"

    return par, "$pai/", joinpath(par, "code", ""), joinpath(par, "output", "")

end

export get_path
