function _score_set(
    element_::Vector{String},
    score_::Vector{Float64},
    set_element_::Vector{String},
    is_::Vector{Float64};
    plot::Bool = true,
    plot_kwargs...,
)::Tuple{Vector{Float64},Float64,Float64}

    n_element = length(element_)

    set_score = 0.0

    set_score_ = Vector{Float64}(undef, n_element)

    extreme = 0.0

    extreme_abs = 0.0

    area = 0.0

    h_sum, m_sum = sum_h_absolute_and_n_m(score_, is_)

    d = 1.0 / m_sum

    @inbounds @fastmath @simd for i = n_element:-1:1

        if is_[i] == 1.0

            f = score_[i]

            if f < 0.0

                f = -f

            end

            set_score += f / h_sum

        else

            set_score -= d

        end

        if plot

            set_score_[i] = set_score

        end

        if set_score < 0.0

            set_score_abs = -set_score

        else

            set_score_abs = set_score

        end

        if extreme_abs < set_score_abs

            extreme = set_score

            extreme_abs = set_score_abs

        end

        area += set_score

    end

    if plot

        display(
            _plot(
                element_,
                score_,
                set_element_,
                is_,
                set_score_,
                extreme,
                area;
                plot_kwargs...,
            ),
        )

    end

    return (set_score_, extreme, area / convert(Float64, n_element))

end

export _score_set
