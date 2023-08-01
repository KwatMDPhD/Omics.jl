using Test: @test

using BioLab

# ---- #

const ID = "DIV_ID"

const SR_ = ("SCRIPT_SRC_1", "SCRIPT_SRC_2")

const SC = "SCRIPT"

# ---- #

@test dirname(BioLab.HTML.make("", ID, SR_, SC)) == BioLab.TE

# ---- #

@test length(readlines(BioLab.HTML.make(joinpath(BioLab.TE, "name.html"), ID, SR_, SC))) ==
      10 + length(SR_)

# ---- #

for ba in ("#000000", "#ffffff")

    BioLab.HTML.make("", ID, SR_, SC; ba)

end
