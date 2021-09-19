using Plotly: Layout, scatter, plot as Plotlyplot

function plot_bar(
    y_::Vector{Vector{Float64}};
    name_::Union{Nothing,Vector{String}} = nothing,
    layout::Union{Nothing,Layout} = nothing,
)::Any

    n_tr = length(y_)

    tr_ = [Dict{String,Any}() for ie = 1:n_tr]

    for ie = 1:n_tr

        tr_[ie]["y"] = y_[ie]

        if name_ == nothing

            name = string(ie)

        else

            name = name_[ie]

        end

        tr_[ie]["name"] = name

        tr_[ie]["opacity"] = 0.8

    end

    tr_ = [bar(tr) for tr in tr_]

    if layout == nothing

        layout = Layout()

    end

    return display(Plotlyplot(tr_, layout))

end

export plot_bar
