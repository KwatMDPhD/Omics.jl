function cumulate_sum_reverse(f_::Vector{Float64})::Vector{Float64}

    return reverse(cumsum(Iterators.reverse(f_)))

end

export cumulate_sum_reverse
