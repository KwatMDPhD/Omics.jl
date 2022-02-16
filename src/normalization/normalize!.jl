function normalize!(te, me)

    go_ = .!isnan.(te)

    if any(go_)

        te[go_] .= normalize(te[go_], me)

    end

end
