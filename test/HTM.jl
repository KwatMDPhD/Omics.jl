using Test: @test

using Omics

# ---- #

const HT = joinpath(tempdir(), "_.html")

Omics.HTM.writ(
    HT,
    ("SRC 1", "SRC 2"),
    "",
    """
    SCRIPT LINE 1
    SCRIPT LINE 2""",
)

@test count(==('\n'), read(HT, String)) === 14

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
