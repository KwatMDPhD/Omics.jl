function normalize!(te, me)

    go_ = [!isnan(nu) for nu in te]

    if any(go_)

        te[go_] = normalize(te[go_], me)

    end

    nothing

end
