using CSV
using DataFrames: DataFrame, names

using Kwat.Support: check_is, sort_like

include("_plot.jl")

function score_set(
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
            _plot(element_, score_, set_element_, is_, set_score_, area; plot_kwargs...),
        )

    end

    return (set_score_, extreme, area / convert(Float64, n_element))

end

function score_set(
    element_::Vector{String},
    score_::Vector{Float64},
    set_element_::Vector{String};
    sort::Bool = true,
    plot::Bool = true,
    plot_kwargs...,
)::Tuple{Vector{Float64},Float64,Float64}

    if sort

        score_, element_ = sort_like(score_, element_)

    end

    return score_set(
        element_,
        score_,
        set_element_,
        check_is(element_, set_element_);
        plot = plot,
        plot_kwargs...,
    )

end

function score_set(
    element_::Vector{String},
    score_::Vector{Float64},
    set_to_element_::Dict{String,Vector{String}};
    sort::Bool = true,
)::Dict{String,Tuple{Vector{Float64},Float64,Float64}}

    if sort

        score_, element_ = sort_like(score_, element_)

    end

    if 10 < length(set_to_element_)

        check = Dict(e => i for (e, i) in zip(element_, 1:length(element_)))

    else

        check = element_

    end

    set_to_d = Dict{String,Tuple{Vector{Float64},Float64,Float64}}()

    for (set, set_element_) in set_to_element_

        set_to_d[set] = score_set(
            element_,
            score_,
            set_element_,
            check_is(check, set_element_);
            plot = false,
        )

    end

    return set_to_d

end

function score_set(
    element_x_sample::DataFrame,
    set_to_element_::Dict{String,Vector{String}};
    n_jo::Int64 = 1,
)::DataFrame

    element_ = element_x_sample[!, 1]

    set_x_sample = DataFrame(:Set => sort(collect(keys(set_to_element_))))

    for sample in names(element_x_sample)[2:end]

        is_good_ = findall(!ismissing, element_x_sample[!, sample])

        set_to_d = score_set(
            element_[is_good_],
            element_x_sample[is_good_, sample],
            set_to_element_;
            sort = true,
        )

        set_x_sample[!, sample] =
            collect(set_to_d[set][end] for set in set_x_sample[!, :Set])

    end

    return set_x_sample

end
