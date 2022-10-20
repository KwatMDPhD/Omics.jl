function shift_minimum(nu_, mi)

    sh = mi - minimum(nu_)

    [nu + sh for nu in nu_]

end

function shift_minimum(nu_, mi::AbstractString)

    shift_minimum(
        nu_,
        minimum(nu_[parse(eltype(nu_), OnePiece.String.split_and_get(mi, "<", 1)) .< nu_]),
    )

end
