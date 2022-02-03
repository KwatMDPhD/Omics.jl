function get_kolmogorov_smirnov_statistic(
    ve1::Vector{Float64},
    ve2::Vector{Float64},
)::Vector{Float64}

    return ve1 - ve2

end
