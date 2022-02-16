function plot(tr_, la = Dict(); ou = "")

    pl = Plot(
        tr_,
        OnePiece.dict.merge(
            Dict("template" => PlotlyLight.template("plotly_dark"), "hovermode" => "closest"),
            la,
        ),
        Dict(
            "modeBarButtonsToRemove" => ["select", "lasso", "resetScale"],
            #"displaylogo" => false,
        ),
    )

    if !isempty(ou)

        Cobweb.save(Cobweb.Page(pl), ou)

    end

    pl

end
