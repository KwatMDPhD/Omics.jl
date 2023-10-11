using Test: @test

using BioLab

# ---- #

# TODO: Remove.
@test BioLab.HTML.get_height() === 800

# ---- #

# TODO: Remove.
@test BioLab.HTML.get_width() === 1280

# ---- #

const HT = joinpath(BioLab.TE, "name.html")

# ---- #

const SR_ = ("SCRIPT_SRC_1", "SCRIPT_SRC_2")

# ---- #

const ID = "DIV_ID"

# ---- #

const SC = "SCRIPT"

# ---- #

BioLab.HTML.make(HT, SR_, ID, SC)

# ---- #

@test length(readlines(HT)) === 10 + length(SR_)

# ---- #

for ba in ("#ff0000", "#0000ff")

    BioLab.HTML.make("", SR_, ID, SC; ba)

end
