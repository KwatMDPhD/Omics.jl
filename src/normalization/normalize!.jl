function normalize!(ve, me)

    go_ = .!isnan.(ve)

    if any(go_)

        ve[go_] .= normalize(ve[go_], me)

    end

end
