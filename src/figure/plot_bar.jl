using PlotlyJS: Layout, SyncPlot, bar

function plot_bar(
    y_::Vector{Vector{Float64}},
    x_::Vector{Vector{String}};
    name_::Vector{String} = Vector{String}(),
    marker_color_::Vector{String} = Vector{String}(),
    la::Layout = Layout(),
    pa::String = "",
)::SyncPlot

    tr_ = [bar(;) for ie in 1:length(y_)]

    for (ie, tr) in enumerate(tr_)

        if 0 < length(name_)

            tr["name"] = name_[ie]

        end

        tr["y"] = y_[ie]

        tr["x"] = x_[ie]

        if 0 < length(marker_color_)

            tr["marker_color"] = marker_color_[ie]

        end

        tr["opacity"] = 0.8

    end

    return plot(tr_, la; pa = pa)

end

function plot_bar(y_::Vector{Vector{Float64}}; ke_ar...)::SyncPlot

    return plot_bar(y_, [string.(1:length(y)) for y in y_]; ke_ar...)

end

export plot_bar
