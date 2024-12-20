using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using JSON: json

# ---- #

const HT = Omics.HTM.writ(
    joinpath(homedir(), "Downloads", "writ.html"),
    ("SRC 1", "SRC 2"),
    "",
    """
    SCRIPT LINE 1
    SCRIPT LINE 2""",
)

const ST = read(HT, String)

@test count(==('\n'), ST) === 14

Omics.Path.ope(HT)

# ---- #

const ID = "id"

# ---- #

Omics.Path.ope(
    Omics.HTM.writ(
        joinpath(tempdir(), "pl.html"),
        ("https://cdn.plot.ly/plotly-2.35.2.min.js",),
        ID,
        """
        Plotly.newPlot(
            "$ID",
            $(json(())),
            $(json(Dict(
                "paper_bgcolor" => "#00ff00",
                "plot_bgcolor" => "#0000ff",
                "title" => Dict("text" => "🤠"),
            ))),
        )""",
    ),
)

# ---- #

Omics.Path.ope(
    Omics.HTM.writ(
        joinpath(tempdir(), "cy.html"),
        ("https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.29.2/cytoscape.min.js",),
        ID,
        """
        var cy = cytoscape({
            container: document.getElementById("$ID"),
            elements: $(json((
                          Dict("data" => Dict("id" => "A"), "position" => Dict("y" => 0, "x" => 0)),
                          Dict("data" => Dict("id" => "B"), "position" => Dict("y" => 80, "x" => 80)),
                      ))),
            layout: $(json(Dict("name" => "preset"))),
        })""",
    ),
)
