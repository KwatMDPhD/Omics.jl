function plot(tr_, la)

    la["template"] = "plotly_white"

    pl = PlotlyJS_plot(
        tr_,
        merge(Layout(autosize = false, hovermode = "closest"), la);
        config = PlotConfig(;
            modeBarButtonsToRemove = ["select", "lasso", "resetScale"],
            displaylogo = false,
        ),
    )

    return pl

end

function plot(tr_)

    return plot(tr_, Layout())

end
