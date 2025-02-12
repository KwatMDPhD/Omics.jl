using JSON: json

using Test: @test

using Omics

# ---- #

const FI = Omics.HTM.writ(
    "",
    ("SRC 1", "SRC 2"),
    "",
    """
    SCRIPT LINE 1
    SCRIPT LINE 2""",
)

const HT = read(FI, String)

@test count(==('\n'), HT) === 14

Omics.Path.ope(FI)

# ---- #

const LA = Dict(
    "paper_bgcolor" => "#ff0000",
    "plot_bgcolor" => "#00ff00",
    "title" => Dict("text" => "🤠"),
)

for la in (
    LA,
    merge(LA, Dict("height" => 800, "width" => 800)),
    merge(LA, Dict("height" => 2000, "width" => 2000)),
)

    Omics.Plot.plot("", (), la)

end
