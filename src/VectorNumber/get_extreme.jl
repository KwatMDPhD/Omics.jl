function get_extreme(nu_)

    mi = minimum(nu_)

    ma = maximum(nu_)

    mia = abs(mi)

    maa = abs(ma)

    if maa < mia

        mi

    else

        if mia == maa

            println("The minimum and the maximum have the same absolute value.")

        end

        ma

    end

end
