function read(pa)

    ex = splitext(pa)[2]

    if ex in [".json", ".ipynb"]

        parse(open(pa))

    elseif ex == ".toml"

        parsefile(pa)


    else

        error("extension is not .json, .ipynb, or .toml.")

    end

end
