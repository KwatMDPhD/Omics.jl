function normalize(te, me)

    if isempty(te)

        error("Tensor is empty.")

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

            error("Tensor values are not all positive.")

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

function normalize(ma, di, me)

    man = Matrix{Real}(undef, size(ma))

    if di == 1

        for (id, ro) in enumerate(eachrow(ma))

            man[id, :] = normalize(ro, me)

        end

    elseif di == 2

        for (id, co) in enumerate(eachcol(ma))

            man[:, id] = normalize(co, me)

        end

    else

        error()

    end

    man

end
