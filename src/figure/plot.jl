using PlotlyJS: GenericTrace, Layout, PlotConfig, attr, savefig
import PlotlyJS: plot as plotlyjl_plot

VGTDSA = Vector{GenericTrace{Dict{Symbol, Any}}}


function plot(tr_::VGTDSA, la::Layout; sc::Float64 = 1.0, pa::String = "")::SP

    la["template"] = "plotly_white"

    la["autosize"] = false

    pl = plotlyjl_plot(tr_, la; config = PlotConfig(; displaylogo = false))

    if pa != ""

        open(pa, "w") do io

            return savefig(
                io,
                pl;
                format = splitext(pa)[end][2:end],
                scale = sc,
            )

        end

    end

    display(pl)

    return pl

end

function plot(tr_::VGTDSA; ke_ar...)::SP

    return plot(tr_, Layout(); ke_ar...)

end

export plot
