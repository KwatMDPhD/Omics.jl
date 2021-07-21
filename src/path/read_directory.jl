function read_directory(di::String; so = true, jo = true)::Vector{String}

    return [
        st for st in readdir(di; sort = so, join = jo) if !startswith(splitdir(st)[2], '.')
    ]

end

export read_directory
