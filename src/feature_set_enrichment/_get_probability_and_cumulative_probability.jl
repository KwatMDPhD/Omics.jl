using ..vector_number: cumulate_sum_reverse

function _get_probability_and_cumulative_probability(ve::VF)::Tuple{VF, VF, VF}

    ep = eps()

    pr_ = ve / sum(ve)

    cur_ = cumsum(pr_) .+ ep

    cul_ = cumulate_sum_reverse(pr_) .+ ep

    return pr_, cur_, cul_

end
