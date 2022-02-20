function read(pa)

    ex = splitext(pa)[2]

    if ex in [".json", ".ipynb"]

        JSON.parse(open(pa))

    elseif ex == ".toml"

        TOML.parsefile(pa)

    else

        error()

    end

end

function read(pa_...)

    di = Dict()

    for pa in pa_

        di = merge(di, read(pa))

    end

    di

end
