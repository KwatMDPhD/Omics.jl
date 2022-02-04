using PlotlyJS: Layout, SyncPlot

function plot_bar(
    y_::Vector{Vector{Float64}},
    x_::Vector{Vector{String}};
    name_::Vector{String} = Vector{String}(),
    marker_color_::Vector{String} = Vector{String}(),
    la::Layout = Layout(),
)::PlotlyJS.SyncPlot

    tr_ = [bar(;) for id = 1:length(y_)]

    for (id, tr) in enumerate(tr_)

        if 0 < length(name_)

            tr["name"] = name_[id]

        end

        tr["y"] = y_[id]

        tr["x"] = x_[id]

        if 0 < length(marker_color_)

            tr["marker_color"] = marker_color_[id]

        end

        tr["opacity"] = 0.8

    end

    return plot(tr_, la)

end

function plot_bar(y_::Vector{Vector{Float64}}; ke_ar...)::PlotlyJS.SyncPlot

    return plot_bar(y_, [string.(1:length(y)) for y in y_]; ke_ar...)

end
