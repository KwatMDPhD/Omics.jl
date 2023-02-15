function shorten(pa, n::Int)

    # TODO: Do not splat.
    return joinpath(splitpath(pa)[clamp(end - n, 1, end):end]...)

end

function shorten(pa, di; sh = 0)

    sp_ = splitpath(pa)

    na = basename(di)

    n = findlast(sp == na for sp in sp_)

    if isnothing(n)

        error()

    end

    return shorten(pa, length(sp_) - n + sh)

end
