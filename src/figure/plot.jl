function plot(tr_, la = Dict(); co = Dict(), ou = "")

    lad = Dict("hovermode" => "closest")

    cod = Dict(
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

        $(JSON3.write(tr_)),

        $(JSON3.write(OnePiece.dict.merge(lad, la))),

        $(JSON3.write(OnePiece.dict.merge(cod, co))),

    )
    """

    OnePiece.html.make(di, sr, sc, ou)

end
