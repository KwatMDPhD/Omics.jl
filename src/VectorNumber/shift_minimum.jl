function shift_minimum(nu_, mi)

    sh = mi - minimum(nu_)

    [nu + sh for nu in nu_]

end

function shift_minimum(nu_, mi::AbstractString)

    shift_minimum(nu_, minimum(nu_[parse(eltype(nu_), split(mi, "<", limit = 2)[1]) .< nu_]))

end
