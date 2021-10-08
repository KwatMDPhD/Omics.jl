using ..path: get_absolute


function get_path(se::String)::Tuple{String, String, String, String}

    se = get_absolute(se)

    if islink(se)

        se = readlink(se)

    end

    par = dirname(dirname(se))

    pai = joinpath(par, "input", "")

    pac = joinpath(par, "code", "")

    pao = joinpath(par, "output", "")

    return par, pai, pac, pao

end

export get_path
