using ColorSchemes: bwr, plasma

using Colors: RGB

using Test: @test

using BioLab

# ---- #

const HE_ = ("#ff71fb", "#fcc9b9", "#c91f37")

const CO = BioLab.Color._make_color_scheme(HE_)

@test length(CO) === length(HE_)

# ---- #

@test BioLab.Color.COBW === bwr

@test BioLab.Color.COPA === plasma

# ---- #

for co in (
    BioLab.Color.COBW,
    BioLab.Color.COPA,
    BioLab.Color.COP3,
    BioLab.Color.COAS,
    BioLab.Color.COPL,
    BioLab.Color.COBI,
    BioLab.Color.COHU,
    BioLab.Color.COST,
    BioLab.Color.COMO,
)

    BioLab.Plot.plot_heat_map(
        "",
        [id for _ in 1:1, id in 1:length(co)];
        text = [BioLab.Color._make_hex(cl) for _ in 1:1, cl in co.colors],
        colorscale = BioLab.Color.fractionate(co),
        layout = Dict("yaxis" => Dict("tickvals" => ()), "xaxis" => Dict("dtick" => 1)),
    )

end

# ---- #

for (rg, re) in ((RGB(1, 0, 0), "#ff0000"), (RGB(0, 1, 0), "#00ff00"), (RGB(0, 0, 1), "#0000ff"))

    @test BioLab.Color._make_hex(rg) === re

end

# ---- #

for he in ("#ff0000", "#00ff00", "#0000ff")

    @test BioLab.Color.add_alpha(he, 0.5) === "$(he)80"

end

# ---- #

for (he_, fr_) in (
    (("#000000", "#ffffff"), (0, 1)),
    (("#ff0000", "#00ff00", "#0000ff"), (0, 0.5, 1)),
    (("#ff0000", "#00ff00", "#0000ff", "#f0000f"), (0, 1 / 3, 2 / 3, 1)),
    (("#ff0000", "#00ff00", "#0000ff", "#f0000f", "#0f00f0"), (0, 0.25, 0.5, 0.75, 1)),
    (
        ("#ff0000", "#00ff00", "#0000ff", "#f0000f", "#0f00f0", "#00ff00"),
        (0, 0.2, 0.4, 0.6, 0.8, 1),
    ),
)

    @test BioLab.Color.fractionate(BioLab.Color._make_color_scheme(he_)) == collect(zip(fr_, he_))

end

# ---- #

for (n, re) in (
    (0, BioLab.Color.COMO),
    (1, BioLab.Color.COMO),
    (2, BioLab.Color.COBI),
    (3, BioLab.Color.COPL),
)

    @test BioLab.Color.pick_color_scheme(rand(n)) === BioLab.Color.COBW

    @test BioLab.Color.pick_color_scheme(rand(Int, n)) === re

end

# ---- #

const N = length(CO)

# ---- #

for nu in (NaN, -1, 0, N + 1)

    @test BioLab.Error.@is CO[nu]

end

# ---- #

for (nu, re) in zip(
    (-Inf, -0.1, 0.0, 0.01, 0.99, 1.0, 1.1, Inf),
    ("#ff71fb", "#ff71fb", "#ff71fb", "#ff73fa", "#ca223a", "#c91f37", "#c91f37", "#c91f37"),
)

    @test BioLab.Color.color(nu, CO) === re

end

# ---- #

@test BioLab.Color.color([1], CO) == ["#fcc9b9"]

# ---- #

const IT_ = [1, 2, N]

# ---- #

for (it, re) in zip(IT_, HE_)

    @test BioLab.Color.color(it, CO) === re

end

# ---- #

@test BioLab.Color.color(IT_, CO) == collect(HE_)

# ---- #

@test BioLab.Color.color(vcat(IT_, N + 1), CO) == [HE_[1], "#fdaccf", "#eb908e", HE_[end]]
