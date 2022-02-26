function plot(tr_, la = Dict(); co = Dict(), ou = "")

    lad = Dict("hovermode" => "closest")

    cod = Dict(
        "modebarbuttonstoremove" => ["select", "lasso", "resetscale"],
        "displaylogo" => false,
        "responsive" => true,
        "editable" => true,
    )

    la = OnePiece.dict.merge(lad, la)

    co = OnePiece.dict.merge(cod, co)

    if isempty(ou)

        ou = joinpath(SC, "index.html")

    end

    open(ou, "w") do io

        id = splitext(basename(ou))[1]

        println(io, "<!doctype html>")

        println(io, "<div id=\"$id\" style=\"height: 100%; width: 100%\"></div>")

        println(io, "<script src=\"https://cdn.plot.ly/plotly-latest.min.js\"></script>")

        println(io, "<script>")

        print(io, "Plotly.newPlot(\"$id\", ")

        JSON3.write(io, tr_)

        print(io, ", ")

        JSON3.write(io, la)

        print(io, ", ")

        JSON3.write(io, co)

        println(io, ");")

        print(io, "</script>\n")

    end

    ou

end
