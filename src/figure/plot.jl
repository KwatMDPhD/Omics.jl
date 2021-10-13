using PlotlyJS: GenericTrace, Layout, PlotConfig, SyncPlot, savefig
import PlotlyJS: plot as PlotlyJS_plot

function plot(
    tr_::Vector{GenericTrace},
    la::Layout;
    sc::Float64 = 1.0,
    pa::String = "",
)::SyncPlot

    la["template"] = "plotly_white"

    pl = PlotlyJS_plot(
        tr_,
        merge(Layout(autosize = false, hovermode = "closest"), la),
        config = PlotConfig(
            modeBarButtonsToRemove = ["select", "lasso", "resetScale"],
            displaylogo = false,
        ),
    )

    if pa != ""

        open(pa, "w") do io

            return savefig(
                io,
                pl,
                format = splitext(pa)[end][2:end],
                scale = sc,
            )

        end

    end

    display(pl)

    return pl

end

function plot(tr_::Vector{GenericTrace}; ke_ar...)::SyncPlot

    return plot(tr_, Layout(), ke_ar...)

end

export plot
