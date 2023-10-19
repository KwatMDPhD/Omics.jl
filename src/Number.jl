module Number

function is_negative(it)

    it < 0

end

function is_negative(fl::AbstractFloat)

    fl < 0 || fl === -0.0

end

function is_positive(nu)

    !is_negative(nu)

end

end
