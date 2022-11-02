function normalize(te, me)

    if isempty(te)

        error()

    end

    if me == "0-1"

        mi = minimum(te)

        ra = maximum(te) - mi

        [(nu - mi) / ra for nu in te]

    elseif me == "-0-"

        ma = mean(te)

        st = std(te)

        [(nu - ma) / st for nu in te]

    elseif me == "sum"

        if any(nu < 0 for nu in te)

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

    else

        error()

    end

end

function normalize(ro_x_co_x_nu, di, me)

    ro_x_co_x_nun = Matrix{Real}(undef, size(ro_x_co_x_nu))

    if di == 1

        for (id, nu_) in enumerate(eachrow(ro_x_co_x_nu))

            ro_x_co_x_nun[id, :] = normalize(nu_, me)

        end

    elseif di == 2

        for (id, nu_) in enumerate(eachcol(ro_x_co_x_nu))

            ro_x_co_x_nun[:, id] = normalize(nu_, me)

        end

    else

        error()

    end

    ro_x_co_x_nun

end
