using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Colors: RGB

# ---- #

@test allunique(Omics.Palette.HE_)

# ---- #

const RG_ = Omics.Palette.make(("#ff0000", "#00ff00", "#0000ff"))

@test lastindex(RG_) === 3

@test RG_[1] === RGB(1, 0, 0)

# ---- #

for (nu_, re) in (
    ([1.0], Omics.Palette.bwr),
    ([1], Omics.Palette.MO),
    (1:2, Omics.Palette.BI),
    (1:3, Omics.Palette.CA),
)

    @test Omics.Palette.pick(nu_) === re

end

# ---- #

const RE = "#ff0000ff"

const GR = "#00ff00ff"

const BL = "#0000ffff"

# ---- #

for (nu, re) in (
    # Indexed.
    (1, RE),
    (2, GR),
    (3, BL),
    # Normalized between 0 and 1.
    (-Inf, RE),
    (-0.1, RE),
    (0.0, RE),
    (0.01, "#fa0500ff"),
    (0.5, GR),
    (0.99, "#0005faff"),
    (1.0, BL),
    (1.1, BL),
    (Inf, BL),
)

    @test Omics.Palette.color(nu, RG_) === re

end

# ---- #

for (nu_, re) in (
    # Normalized between the extrema.
    ([NaN], [GR]),
    (1:1, [GR]),
    (1:2, [RE, BL]),
    (1:3, [RE, GR, BL]),
    (1:4, [RE, "#55aa00ff", "#00aa55ff", BL]),
)

    @test Omics.Palette.color(nu_, RG_) == re

end

# ---- #

for (he_, re) in (
    (Omics.Palette.make(("#ff0000",)), [(0, RE), (1, RE)]),
    (Omics.Palette.make(("#ff0000", "#00ff00")), [(0, RE), (1, GR)]),
    (RG_, [(0, RE), (0.5, GR), (1, BL)]),
)

    @test Omics.Palette.fractionate(Omics.Palette.make(he_)) == re

end
