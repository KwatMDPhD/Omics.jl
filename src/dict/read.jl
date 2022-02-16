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
