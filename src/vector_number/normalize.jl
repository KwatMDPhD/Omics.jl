function normalize(ve::Vector{Float64}, me::String)::Vector{Float64}

    if me == "-0-"

        ven = (ve .- mean(ve)) / std(ve)

    elseif me == "0-1"

        me = minimum(ve)

        ven = (ve .- me) / (maximum(ve) - me)

    elseif me == "sum"

        if any(ve .< 0.0)

            error("method sum can not normalize a vector containing any negative number.")

        end

        ven = ve / sum(ve)

    elseif me == "1234"

        ven = ordinalrank(ve)

    elseif me == "1224"

        ven = competerank(ve)

    elseif me == "1223"

        ven = denserank(ve)

    elseif me == "1 2.5 2.5 4"

        ven = tiedrank(ve)

    end

    return ven

end

export normalize
