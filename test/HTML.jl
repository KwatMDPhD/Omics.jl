using Test: @test

using BioLab

# ---- #

const ID = "DIV_ID"

const SO_ = ("SOURCE_1", "SOURCE_2")

const SC = "SCRIPT"

# ---- #

BioLab.HTML.make("", ID, SO_, SC)

# ---- #

for ba in ("#000000", "#ffffff")

    ht = joinpath(BioLab.TE, "$ba.html")

    BioLab.HTML.make(ht, ID, SO_, SC; ba)

    @test length(readlines(ht)) == 10 + length(SO_)

end
