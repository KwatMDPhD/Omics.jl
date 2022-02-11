LA = Config(template = "plotly_white", autosize = false, hovermode = "closest")

CO = Config(modeBarButtonsToRemove = ["select", "lasso", "resetScale"], displaylogo = false)

function plot(tr_, la, co = CO; ou = "")

    pl = Plot(tr_, merge(LA, la), co)

    if ou != ""

        save(Page(pl), ou)

    end

    pl

end

function plot(tr_; ke_ar...)

    plot(tr_, Config(); ke_ar...)

end
