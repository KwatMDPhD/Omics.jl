using JSON: json

using Test: @test

using Omics

# ---- #

const HT = Omics.HTM.writ(
    joinpath(tempdir(), "writ.html"),
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

const SR_ = ("https://cdn.plot.ly/plotly-2.35.2.min.js",)

const DA = json(())

const LA = Dict(
    "paper_bgcolor" => "#00ff00",
    "plot_bgcolor" => "#0000ff",
    "title" => Dict("text" => "🤠"),
)

# ---- #

Omics.Path.ope(
    Omics.HTM.writ(
        joinpath(tempdir(), "pl1.html"),
        SR_,
        ID,
        """Plotly.newPlot("$ID", $DA, $(json(LA)))""",
    ),
)

# ---- #

Omics.Path.ope(
    Omics.HTM.writ(
        joinpath(tempdir(), "pl2.html"),
        SR_,
        ID,
        """Plotly.newPlot("$ID", $DA, $(json(merge(LA, Dict("height" => 800, "width" => 800)))))""",
    ),
)

# ---- #

Omics.Path.ope(
    Omics.HTM.writ(
        joinpath(tempdir(), "pl3.html"),
        SR_,
        ID,
        """Plotly.newPlot("$ID", $DA, $(json(merge(LA, Dict("height" => 2000, "width" => 2000)))))""",
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
