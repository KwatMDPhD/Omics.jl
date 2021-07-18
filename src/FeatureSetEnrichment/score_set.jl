using CSV
using DataFrames: DataFrame, names

include("../Support/check_is.jl")
include("../Support/sort_like.jl")

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

    return _score_set(
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

        set_to_d[set] = _score_set(
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
    n_job::Int64 = 1,
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



function score_set(
    element_x_sample_path::String,
    gmt_path_::Vector{String},
    directory_path::String,
)::DataFrame

    element_set_x_sample = DataFrame()

    # write element_set_x_sample directory_path

    return element_set_x_sample

end

export score_set
