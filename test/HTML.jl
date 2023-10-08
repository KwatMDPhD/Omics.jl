using Test: @test

using BioLab

# ---- #

@test BioLab.HTML.get_height() === 800

# ---- #

@test BioLab.HTML.get_width() === 1280

# ---- #

const SR_ = ("SCRIPT_SRC_1", "SCRIPT_SRC_2")

# ---- #

const ID = "DIV_ID"

# ---- #

const SC = "SCRIPT"

# ---- #

@test dirname(BioLab.HTML.make("", SR_, ID, SC)) === BioLab.TE

# ---- #

@test length(readlines(BioLab.HTML.make(joinpath(BioLab.TE, "name.html"), SR_, ID, SC))) ===
      10 + length(SR_)

# ---- #

for ba in ("#ff0000", "#0000ff")

    BioLab.HTML.make("", SR_, ID, SC; ba)

end
