using Test: @test

using BioLab

# ---- #

const HT = joinpath(BioLab.TE, "name.html")

# ---- #

const SR_ = ("SRC_1", "SRC_2")

# ---- #

const ID = "ID"

# ---- #

const SC = "SCRIPT"

# ---- #

BioLab.HTML.make(HT, SR_, ID, SC)

# ---- #

@test lastindex(readlines(HT)) === 10 + lastindex(SR_)

# ---- #

for ba in ("#ff0000", "#0000ff")

    BioLab.HTML.make("", SR_, ID, SC; ba)

end
