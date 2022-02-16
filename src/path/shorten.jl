function shorten(sp_::AbstractVector, n_ba)

    joinpath(sp_[(end - n_ba):end]...)

end

function shorten(pa, n_ba)

    shorten(splitpath(pa), n_ba)

end

function shorten(pa, di::AbstractString)

    sp_ = splitpath(pa)

    n_sk = findlast(sp_ .== basename(di))

    if isnothing(n_sk)

        error()

    end

    shorten(sp_, length(sp_) - n_sk)

end
