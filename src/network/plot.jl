function plot(el_, st_, la, ou = "")

    di = "plot"

    sr = "https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.1/cytoscape.min.js"

    sc = """
    var cy = cytoscape({

        container: document.getElementById("$di"),

        elements: $(JSON3.write(el_)),

        style: $(JSON3.write(st_)),

        layout: $(JSON3.write(la)),

    })
    """

    OnePiece.html.make(di, sr, sc, ou)

end
