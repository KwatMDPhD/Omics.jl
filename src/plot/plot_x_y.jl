using Plotly: Layout, plot as Plotlyplot, scatter

function plot_x_y(
    x_::Vector{Vector{Float64}},
    y_::Vector{Vector{Float64}};
    text_::Union{Nothing,Vector{Vector{String}}} = nothing,
    name_::Union{Nothing,Vector{String}} = nothing,
    mode_::Union{Nothing,Vector{String}} = nothing,
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

        if text_ !== nothing

            tr_[ie]["text"] = text_[ie]

        end


        if mode_ == nothing

            if length(x_[ie]) < 1000

                mode = "markers"

            else

                mode = "lines"

            end

        else

            mode = mode_[ie]

        end

        tr_[ie]["mode"] = mode

        tr_[ie]["opacity"] = 0.8

    end

    tr_ = [scatter(tr) for tr in tr_]

    if layout == nothing

        layout = Layout()

    end

    return display(Plotlyplot(tr_, layout))

end

function plot_x_y(y_::Vector{Vector{Float64}}; ke_ar...)::Any

    return plot_x_y([Float64.(1:length(y)) for y in y_], y_; ke_ar...)

end

export plot_x_y
