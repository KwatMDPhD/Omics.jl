using Test: @test

using BioLab

# ---- #

const ID = "DIV_ID"

const SR_ = ("SCRIPT_SRC_1", "SCRIPT_SRC_2")

const SC = "SCRIPT"

# ---- #

BioLab.HTML.make("", ID, SR_, SC)

# ---- #

const HT = joinpath(BioLab.TE, "name.html")

BioLab.HTML.make(HT, ID, SR_, SC)

@test length(readlines(HT)) == 10 + length(SR_)

# ---- #

for ba in ("#000000", "#ffffff")

    BioLab.HTML.make("", ID, SR_, SC; ba)

end
