function normalize(ve, me)

    if isempty(ve)

        error("vector is empty.")

    end

    if me == "0-1"

        mi = minimum(ve)

        return (ve .- mi) / (maximum(ve) - mi)

    elseif me == "-0-"

        return (ve .- mean(ve)) / std(ve)

    elseif me == "sum"

        if any(ve .< 0)

            error("\"sum\" can not normalize vectors containing any negative number.")

        end

        return ve / sum(ve)

    elseif me == "1223"

        return denserank(ve)

    elseif me == "1224"

        return competerank(ve)

    elseif me == "1 2.5 2.5 4"

        return tiedrank(ve)

    elseif me == "1234"

        return ordinalrank(ve)

    end

end
