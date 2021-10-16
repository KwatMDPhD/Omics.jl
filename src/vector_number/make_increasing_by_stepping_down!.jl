function make_increasing_by_stepping_down!(
    ic_::Vector{Float64},
)::Vector{Float64}

    accumulate!(max, ic_, ic_)

    return ic_

end

export make_increasing_by_stepping_down
