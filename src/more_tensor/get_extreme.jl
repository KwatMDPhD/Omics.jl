function get_extreme(ve::Vector{Float64})::Float64

    mi = minimum(ve)

    ma = maximum(ve)

    mia = abs(mi)

    maa = abs(ma)

    if mia < maa

        return ma

    else

        if mia == maa

            println(
                "The minimum and the maximum have the same absolute value; returning the minimum.",
            )

        end

        return mi

    end

end
