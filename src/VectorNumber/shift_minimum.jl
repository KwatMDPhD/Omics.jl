function shift_minimum(nu_, mi::Real)

    sh = mi - minimum(nu_)

    [nu + sh for nu in nu_]

end

function shift_minimum(nu_, mi)

    mi = parse(eltype(nu_), OnePiece.String.split_and_get(mi, "<", 1))

    shift_minimum(nu_, minimum(nu_[[mi < nu for nu in nu_]]))

end
