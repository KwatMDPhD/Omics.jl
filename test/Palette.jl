using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

const RG_ = Omics.Palette.make(["#ff0000", "#00ff00", "#0000ff"])

@test lastindex(RG_) === 3

# ---- #

for (nu_, re) in (
    ([1.0], Omics.Palette.bwr),
    ([1], Omics.Palette.MO),
    ([1, 2], Omics.Palette.BI),
    ([1, 2, 3], Omics.Palette.CA),
)

    @test Omics.Palette.pick(nu_) === re

end

# ---- #

for (nu, re) in (
    # Indexed.
    (1, "#ff0000ff"),
    (2, "#00ff00ff"),
    (3, "#0000ffff"),
    # Normalized between 0 and 1.
    (-Inf, "#ff0000ff"),
    (-0.1, "#ff0000ff"),
    (0.0, "#ff0000ff"),
    (0.01, "#fa0500ff"),
    (0.5, "#00ff00ff"),
    (0.99, "#0005faff"),
    (1.0, "#0000ffff"),
    (1.1, "#0000ffff"),
    (Inf, "#0000ffff"),
)

    @test Omics.Palette.color(nu, RG_) === re

end

# ---- #

for (nu_, re) in (
    # Normalized between the extrema.
    ([NaN], ["#00ff00ff"]),
    ([-1], ["#00ff00ff"]),
    ([0], ["#00ff00ff"]),
    ([4], ["#00ff00ff"]),
    (1:3, ["#ff0000ff", "#00ff00ff", "#0000ffff"]),
    (1:4, ["#ff0000ff", "#55aa00ff", "#00aa55ff", "#0000ffff"]),
)

    @test Omics.Palette.color(nu_, RG_) == re

end

# ---- #

for (he_, re) in (
    (["#ff0000"], [(0, "#ff0000ff"), (1, "#ff0000ff")]),
    (["#ff0000", "#00ff00"], [(0.0, "#ff0000ff"), (1.0, "#00ff00ff")]),
    (
        ["#ff0000", "#00ff00", "#0000ff"],
        [(0.0, "#ff0000ff"), (0.5, "#00ff00ff"), (1.0, "#0000ffff")],
    ),
)

    @test Omics.Palette.fractionate(Omics.Palette.make(he_)) == re

end
