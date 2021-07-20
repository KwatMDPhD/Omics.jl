function get_extreme(v::Vector{Float64})::Float64

    mi = minimum(v)

    ma = maximum(v)

    mi_a = abs(mi)

    ma_a = abs(ma)

    if mi_a < ma_a

        return ma

    else

        if mi_a == ma_a

            println(
                "The minimum and the maximum have the same absolute value; returning the minimum.",
            )

        end

        return mi

    end

end

export get_extreme
