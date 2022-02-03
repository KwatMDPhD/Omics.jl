function make_increasing_by_stepping_up!(ic_::Vector{Float64})::Vector{Float64}

    accumulate!(min, ic_, reverse!(ic_))

    reverse!(ic_)

    return ic_

end
