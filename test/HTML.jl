using Test: @test

using BioLab

# ---- #

const ID = "DIV_ID"

const SO_ = ("SOURCE_1", "SOURCE_2")

const SC = "SCRIPT"

# ---- #

BioLab.HTML.make("", ID, SO_, SC)

# ---- #

const HT = joinpath(BioLab.TE, "name.html")

BioLab.HTML.make(HT, ID, SO_, SC)

@test length(readlines(HT)) == 10 + length(SO_)

# ---- #

for ba in ("#000000", "#ffffff")

    BioLab.HTML.make("", ID, SO_, SC; ba)

end
