using PlotlyJS: Layout, SyncPlot, heatmap

function plot_heat_map(; la::Layout = Layout(), pa::String = "")::SyncPlot

    tr_ = []

    return plot(tr_, la; pa = pa)

end

export plot_heat_map
