
function get_probability_and_cumulate(
    ve::Vector{Float64},
)::Tuple{Vector{Float64}, Vector{Float64}, Vector{Float64}}

    pr_ = ve / sum(ve)

    ep = eps()

    cur_ = cumsum(pr_) .+ ep

    cul_ = cumulate_sum_reverse(pr_) .+ ep

    return pr_, cur_, cul_

end
