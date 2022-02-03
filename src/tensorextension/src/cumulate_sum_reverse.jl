function cumulate_sum_reverse(ve::Vector{Float64})::Vector{Float64}

    return reverse(cumsum(Iterators.reverse(ve)))

end
