function read(pa::AbstractString)

    ex = splitext(pa)[2]

    if ex in (".json", ".ipynb")

        parse(open(pa))

    elseif ex == ".toml"

        parsefile(pa)

    else

        error()

    end

end

function read(pa_)

    di = Base.Dict()

    for pa in pa_

        di = merge(di, read(pa))

    end

    di

end
