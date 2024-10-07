using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Colors: RGB

# ---- #

const ST_ = (
    "red",
    " red ",
    "RED",
    " RED ",
    "#f00",
    " #f00 ",
    "#F00",
    " #F00 ",
    "#ff0000",
    " #ff0000 ",
    "#FF0000",
    " #FF0000 ",
)

# ---- #

@test unique(map(Omics.Color.pars, ST_))[] === RGB(1, 0, 0)

# ---- #

@test unique(map(st -> st |> Omics.Color.pars |> Omics.Color.hexify, ST_))[] === "#ff0000"

# ---- #

for (al, re) in ((0, "#00000000"), (0.5, "#00000080"), (1, "#000000ff"))

    @test Omics.Color.fade("#000000", al) === Omics.Color.fade("#00000000", al) === re

end
