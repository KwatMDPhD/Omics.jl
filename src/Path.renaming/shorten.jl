function shorten(sp_::AbstractVector, n_ba; sh = 0)

    joinpath(sp_[clamp(end - n_ba + sh, 1, end):end]...)

end

function shorten(pa, n_ba; ke_ar...)

    shorten(splitpath(pa), n_ba; ke_ar...)

end

function shorten(pa, di::AbstractString; ke_ar...)

    sp_ = splitpath(pa)

    n_sk = findlast(sp_ .== basename(di))

    if isnothing(n_sk)

        error()

    end

    shorten(sp_, length(sp_) - n_sk; ke_ar...)

end
