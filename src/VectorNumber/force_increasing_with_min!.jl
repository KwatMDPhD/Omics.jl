function force_increasing_with_min!(nu_)

    accumulate!(min, nu_, reverse!(nu_))

    reverse!(nu_)

    return nothing

end
