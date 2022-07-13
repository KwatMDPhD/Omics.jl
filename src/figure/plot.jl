function plot(data, layout = Dict(); config = Dict(), ou = "")

    layout0 = Dict("hovermode" => "closest")

    config0 = Dict(
        "modebarbuttonstoremove" => ["select", "lasso", "resetscale"],
        "displaylogo" => false,
        "responsive" => true,
        "editable" => false,
    )

    di = "plot"

    sr = ["https://cdn.plot.ly/plotly-latest.min.js"]

    sc = """
    Plotly.newPlot(

        \"$di\",

        $(JSON3.write(data)),

        $(JSON3.write(OnePiece.dict.merge(layout0, layout))),

        $(JSON3.write(OnePiece.dict.merge(config0, config))),

    )
    """

    OnePiece.html.make(di, sr, sc, ou)

end
