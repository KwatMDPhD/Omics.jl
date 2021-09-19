using Plotly: Layout, attr, bar, plot as Plotlyplot

function plot_bar(
    x_::Vector{Vector{String}},
    y_::Vector{Vector{Float64}};
    name_::Union{Nothing,Vector{String}} = nothing,
    marker_color_::Union{Nothing,Vector{String}} = nothing,
    layout::Union{Nothing,Layout} = nothing,
)::Any

    n_tr = length(x_)

    tr_ = [Dict{String,Any}() for ie = 1:n_tr]

    for ie = 1:n_tr

        if name_ !== nothing

            tr_[ie]["name"] = name_[ie]

        end

        tr_[ie]["x"] = x_[ie]

        tr_[ie]["y"] = y_[ie]

        if marker_color_ !== nothing

            tr_[ie]["marker"] = attr(color = marker_color_[ie])

        end

        tr_[ie]["opacity"] = 0.8

    end

    tr_ = [bar(tr) for tr in tr_]

    if layout == nothing

        layout = Layout()

    end

    return display(Plotlyplot(tr_, layout))

end

function plot_bar(y_::Vector{Vector{Float64}}; ke_ar...)::Any

    return plot_bar([string.(1:length(y)) for y in y_], y_; ke_ar...)

end

export plot_bar
