function format(nu)

    if nu == -0.0

        nu = 0.0

    end

    return @sprintf("%.4g", nu)

end
