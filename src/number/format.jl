function format(nu)

    if iszero(nu)

        nu = 0.0

    end

    @sprintf("%.4g", nu)

end
