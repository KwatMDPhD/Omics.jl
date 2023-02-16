function read(pa::AbstractString)

    ex = splitext(pa)[2]

    if ex in (".json", ".ipynb")

        return parse(open(pa))

    elseif ex == ".toml"

        return parsefile(pa)

    else

        error()

    end

end

function read(pa_)

    ke_va = Base.Dict()

    for pa in pa_

        ke_va = merge(ke_va, read(pa), "last")

    end

    return ke_va

end
