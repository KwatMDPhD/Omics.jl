function normalize(te, me)

    if isempty(te)

        error()

    end

    if me == "0-1"

        mi = minimum(te)

        (te .- mi) / (maximum(te) - mi)

    elseif me == "-0-"

        (te .- mean(te)) / std(te)

    elseif me == "sum"

        if any(te .< 0)

            error()

        end

        te / sum(te)

    elseif me == "1223"

        denserank(te)

    elseif me == "1224"

        competerank(te)

    elseif me == "1 2.5 2.5 4"

        tiedrank(te)

    elseif me == "1234"

        ordinalrank(te)

    end

end
