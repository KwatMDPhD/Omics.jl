using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

const RG_ = Omics.Palette.make(("#ff0000", "#00ff00", "#0000ff"))

@test lastindex(RG_) === 3

# ---- #

for (nu_, re) in (
    ([1.0], Omics.Palette.bwr),
    ([1], Omics.Palette.make((Omics.Color.RE,))),
    ([1, 2], Omics.Palette.make((Omics.Color.LI, Omics.Color.DA))),
    ([1, 2, 3], Omics.Palette.make((Omics.Color.RE, Omics.Color.GR, Omics.Color.BL),)),
)

    rg_ = Omics.Palette.pick(nu_)

    @test lastindex(rg_) == lastindex(re)

    @test all(rg_[id] == re[id] for id in 1:lastindex(rg_))

end

# ---- #

for rg_ in (
    Omics.Palette.bwr,
    Omics.Palette.pick(1:1),
    Omics.Palette.pick(1:2),
    Omics.Palette.pick(1:19),
)

    Omics.Plot.plot_heat_map(
        "",
        reshape(1:lastindex(rg_), 1, :);
        co_ = map(Omics.Color.hexify, rg_),
        rg_,
        la = Dict("height" => 320, "yaxis" => Dict("tickvals" => ())),
    )

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
    (("#ff0000",), [(0, "#ff0000ff"), (1, "#ff0000ff")]),
    (("#ff0000", "#00ff00"), [(0.0, "#ff0000ff"), (1.0, "#00ff00ff")]),
    (
        ("#ff0000", "#00ff00", "#0000ff"),
        [(0.0, "#ff0000ff"), (0.5, "#00ff00ff"), (1.0, "#0000ffff")],
    ),
)

    @test Omics.Palette.fractionate(Omics.Palette.make(he_)) == re

end
