function read_directory(pa::String; so = true, jo = true)::Vector{String}

    return [
        st for st in readdir(pa; sort = so, join = jo) if !startswith(splitdir(st)[2], '.')
    ]

end

export read_directory
