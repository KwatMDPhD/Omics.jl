function plot(tr_::Vector{GenericTrace{Dict{Symbol,Any}}}, la::Layout)::PlotlyJS.SyncPlot

    la["template"] = "plotly_white"

    pl = PlotlyJS.plot(
        tr_,
        merge(Layout(autosize = false, hovermode = "closest"), la);
        config = PlotConfig(;
            modeBarButtonsToRemove = ["select", "lasso", "resetScale"],
            displaylogo = false,
        ),
    )

    display(pl)

    return pl

end

function plot(tr_::Vector{GenericTrace{Dict{Symbol,Any}}}; ke_ar...)::PlotlyJS.SyncPlot

    return plot(tr_, Layout(); ke_ar...)

end
