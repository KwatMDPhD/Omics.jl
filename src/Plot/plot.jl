function plot(data, layout = Dict(), config = Dict(); ht = "")

    axis = Dict("automargin" => true)

    layout0 = Dict("hovermode" => "closest", "yaxis" => axis, "xaxis" => axis)

    config0 = Dict(
        "modebarbuttonstoremove" => ["select", "lasso", "resetscale"],
        "displaylogo" => false,
        "responsive" => true,
        "editable" => false,
    )

    di = "OnePiece.figure.Plot.$(OnePiece.Time.stamp())"

    sr = ["https://cdn.plot.ly/plotly-latest.min.js"]

    sc = """
    Plotly.newPlot(

        \"$di\",

        $(write(data)),

        $(write(OnePiece.Dict.merge(layout0, layout))),

        $(write(OnePiece.Dict.merge(config0, config))),

    )
    """

    OnePiece.HTML.make(di, sr, sc, ht)

end
