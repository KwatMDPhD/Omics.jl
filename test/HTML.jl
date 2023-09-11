using Test: @test

using BioLab

# ---- #

const SR_ = ("SCRIPT_SRC_1", "SCRIPT_SRC_2")

const ID = "DIV_ID"

const SC = "SCRIPT"

# ---- #

@test dirname(BioLab.HTML.make("", SR_, ID, SC)) === BioLab.TE

# ---- #

@test length(readlines(BioLab.HTML.make(joinpath(BioLab.TE, "name.html"), SR_, ID, SC))) ===
      10 + length(SR_)

# ---- #

for ba in ("#000000", "#ffffff")

    BioLab.HTML.make("", SR_, ID, SC; ba)

end
