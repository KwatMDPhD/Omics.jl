function read_directory(p::String; sort = true, join = true)::Vector{String}

    return [
        s for
        s in readdir(p; sort = sort, join = join) if !startswith(splitpath(s)[end], '.')
    ]

end

export read_directory
