function shift_minimum(nu_, mi::Real)

    sh = mi - minimum(nu_)

    [nu + sh for nu in nu_]

end

function shift_minimum(nu_, st)

    fl = parse(eltype(nu_), BioLab.String.split_and_get(st, '<', 1))

    shift_minimum(nu_, minimum(nu_[[fl < nu for nu in nu_]]))

end
