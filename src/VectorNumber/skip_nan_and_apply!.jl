function skip_nan_and_apply!!(nu_, fu!)

    go_ = [!isnan(nu) for nu in nu_]

    if any(go_)

        fu!(view(nu_, go_))

    end

    return nothing

end

function skip_nan_and_apply!(nu_, fu)

    go_ = [!isnan(nu) for nu in nu_]

    if any(go_)

        nu_[go_] = fu(nu_[go_])

    end

    return nothing

end
