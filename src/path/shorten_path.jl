function shorten_path(pa::String, n_ba::Int64)::String

    return joinpath(splitpath(pa)[(end - n_ba):end]...)

end

function shorten_path(pa::String, di::String)::String

    sp_ = splitpath(pa)

    id = findfirst(sp_ .== split(di, "/")[end]) + 1

    return shorten_path(pa, length(sp_) - id)

end

export shorten_path
