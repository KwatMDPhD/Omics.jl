function make_increasing_by_stepping_up!(ic_)

    accumulate!(min, ic_, reverse!(ic_))

    reverse!(ic_)

    ic_

end
