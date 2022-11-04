function shorten(pa, n::Real)

    joinpath(splitpath(pa)[clamp(end - n, 1, end):end]...)

end

function shorten(pa, di, sh = 0)

    sp_ = splitpath(pa)

    na = basename(di)

    n = findlast(==(na), sp_)

    if isnothing(n)

        error()

    end

    shorten(pa, length(sp_) - n + sh)

end
