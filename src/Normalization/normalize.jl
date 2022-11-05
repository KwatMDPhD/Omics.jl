function normalize(te, ho)

    if isempty(te)

        error()

    end

    if ho == "0-1"

        mi = minimum(te)

        ra = maximum(te) - mi

        [(nu - mi) / ra for nu in te]

    elseif ho == "-0-"

        me = mean(te)

        st = std(te)

        [(nu - me) / st for nu in te]

    elseif ho == "sum"

        if any(nu < 0.0 for nu in te)

            error()

        end

        te / sum(te)

    elseif ho == "1223"

        denserank(te)

    elseif ho == "1224"

        competerank(te)

    elseif ho == "1 2.5 2.5 4"

        tiedrank(te)

    elseif ho == "1234"

        ordinalrank(te)

    else

        error()

    end

end

function normalize(ro_x_co_x_nu, di, ho)

    ro_x_co_x_nun = Matrix{Real}(undef, size(ro_x_co_x_nu))

    if di == 1

        for (id, nu_) in enumerate(eachrow(ro_x_co_x_nu))

            ro_x_co_x_nun[id, :] = normalize(nu_, ho)

        end

    elseif di == 2

        for (id, nu_) in enumerate(eachcol(ro_x_co_x_nu))

            ro_x_co_x_nun[:, id] = normalize(nu_, ho)

        end

    else

        error()

    end

    ro_x_co_x_nun

end
