function get_extreme(nu_)

    mi = minimum(nu_)

    ma = maximum(nu_)

    mia = abs(mi)

    maa = abs(ma)

    if isapprox(mia, maa)

        return (mi, ma)

    elseif maa < mia

        return (mi,)

    elseif mia < maa

        return (ma,)

    else

        error()

    end

end
