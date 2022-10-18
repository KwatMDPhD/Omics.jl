function get_extreme(te)

    mi = minimum(te)

    ma = maximum(te)

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
