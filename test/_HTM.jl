using LeMoHTML

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

const HT = LeMoHTML.write(
    joinpath(tempdir(), "name.html"),
    ("SRC 1", "SRC 2"),
    "SCRIPT";
    ba = "#ff0000",
)

# ---- #

@test lastindex(readlines(HT)) === 12

# ---- #

run(`open --background $HT`)

# ---- #

println(read(HT, String))
