function shorten(pa::String, n_ba::Int64)::String

    return joinpath(splitpath(pa)[(end-n_ba):end]...)

end

function shorten(pa::String, di::String)::String

    sp_ = splitpath(pa)

    id = findfirst(sp_ .== split(di, "/")[end])

    n_sp = length(sp_)

    if isnothing(id)

        error(di, " is not part of ", pa)

    elseif id == n_sp

        return ""

    else

        n_ba = id + 1

    end

    return shorten(pa, n_sp - n_ba)

end
