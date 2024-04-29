using Test: @test

using Nucleus

# ---- #

const HT = joinpath(Nucleus.TE, "name.html")

# ---- #

Nucleus.HTML.make(HT, ("SRC_1", "SRC_2"), "ID", "SCRIPT")

# ---- #

@test lastindex(readlines(HT)) === 12

# ---- #

Nucleus.HTML.make("", ("SRC_1", "SRC_2"), "ID", "SCRIPT"; ba = "#ff0000")
