using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Colors: RGB

# ---- #

const RE = "#ff0000ff"

# ---- #

@test Omics.Color.hexify(RGB(1, 0, 0)) === RE

# ---- #

for st in ("red", "#f00", "#ff0000")

    @test Omics.Color.hexify(st, 0) === "#ff000000"

    @test Omics.Color.hexify(st, 0.5) === "#ff000080"

    @test Omics.Color.hexify(st) === RE

end
