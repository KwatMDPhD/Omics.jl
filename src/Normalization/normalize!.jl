function normalize!(te, me)

    go_ = [!isnan(nu) for nu in te]

    if any(go_)

        te[go_] = normalize(te[go_], me)

    end

end

function normalize!(ma::Matrix, di, me)

    if di == 1

        ea = eachrow

    elseif di == 2

        ea = eachcol

    end

    for nu_ in ea(ma)

        normalize!(nu_, me)

    end

    ma

end
