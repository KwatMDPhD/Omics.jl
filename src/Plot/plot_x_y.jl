using Plotly: Layout, plot, scatter

function plot_x_y(
    x_::Vector{Vector{Float64}},
    y_::Vector{Vector{Float64}};
    text_::Union{Nothing,Vector{Vector{String}}} = nothing,
    name_::Union{Nothing,Vector{String}} = nothing,
    mode_::Union{Nothing,Vector{String}} = nothing,
    layout::Union{Nothing,Layout} = nothing,
)::Any

    n = length(x_)

    trace_ = [Dict{String,Any}() for i = 1:n]

    for i = 1:n

        trace_[i]["x"] = x_[i]

        trace_[i]["y"] = y_[i]

        if text_ == nothing

            text = nothing

        else

            text = text_[i]

        end

        trace_[i]["text"] = text

        if name_ == nothing

            name = string(i)

        else

            name = name_[i]

        end

        trace_[i]["name"] = name

        if mode_ == nothing

            if length(x_[i]) < 1000

                mode = "markers"

            else

                mode = "lines"

            end

        else

            mode = mode_[i]

        end

        trace_[i]["mode"] = mode

        trace_[i]["opacity"] = 0.8

    end

    trace_ = [scatter(trace) for trace in trace_]

    if layout == nothing

        layout = Layout()

    end

    return plot(trace_, layout)

end

function plot_x_y(y_::Vector{Vector{Float64}}; kwargs...)::Any

    return plot_x_y([Float64.(1:length(y)) for y in y_], y_; kwargs...)

end

export plot_x_y
