LA = Config(template = "plotly_white", autosize = false, hovermode = "closest")

CO = Config(modeBarButtonsToRemove = ["select", "lasso", "resetScale"], displaylogo = false)

function plot(tr_, la, co = CO)

    Plot(tr_, merge(LA, la), co)

end

function plot(tr_)

    plot(tr_, Config())

end
