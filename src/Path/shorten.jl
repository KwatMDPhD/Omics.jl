function shorten(pa, n_ba)

    joinpath(splitpath(pa)[clamp(end - n_ba, 1, end):end]...)

end

function shorten(pa, di::AbstractString, sh = 0)

    sp_ = splitpath(pa)

    ba = basename(di)

    n_sk = findlast(sp == ba for sp in sp_)

    if isnothing(n_sk)

        error()

    end

    shorten(pa, length(sp_) - n_sk + sh)

end
