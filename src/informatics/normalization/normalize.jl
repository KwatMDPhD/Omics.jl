function normalize(ve, me)

    if isempty(ve)

        error("vector is empty.")

    end

    if me == "0-1"

        mi = minimum(ve)

        (ve .- mi) / (maximum(ve) - mi)

    elseif me == "-0-"

        (ve .- mean(ve)) / std(ve)

    elseif me == "sum"

        if any(ve .< 0)

            error("\"sum\" can not normalize vectors containing any negative number.")

        end

        ve / sum(ve)

    elseif me == "1223"

        denserank(ve)

    elseif me == "1224"

        competerank(ve)

    elseif me == "1 2.5 2.5 4"

        tiedrank(ve)

    elseif me == "1234"

        ordinalrank(ve)

    end

end
