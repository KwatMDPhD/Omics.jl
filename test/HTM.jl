using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

const HT = joinpath(tempdir(), "writ.html")

# ---- #

Omics.HTM.writ(
    HT,
    ("SRC 1", "SRC 2"),
    """
    SCRIPT 1
    SCRIPT 2""";
    ba = "#ff0000",
)

const ST = read(HT, String)

println(ST)

@test count(==('\n'), ST) === 15

Omics.Path.ope(HT)

# ---- #

Omics.Plot.plot(HT, (), Dict("paper_bgcolor" => "#00ff00", "plot_bgcolor" => "#0000ff"))
