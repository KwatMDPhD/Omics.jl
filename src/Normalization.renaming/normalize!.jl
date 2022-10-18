function normalize!(te, me)

    go_ = .!isnan.(te)

    if any(go_)

        te[go_] .= normalize(te[go_], me)

    end

end

function normalize!(ma::Matrix, di, me)

    if di == 1

        ea = eachrow

    elseif di == 2

        ea = eachcol

    end

    normalize!.(ea(ma), me)

    ma

end
