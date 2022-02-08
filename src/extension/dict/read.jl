function read(pa)

    ex = splitext(pa)[2]

    if ex == ".json"

        return parse(open(pa))

    elseif ex == ".toml"

        return parsefile(pa)

    end

end
