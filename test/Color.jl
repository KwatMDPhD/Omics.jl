using ColorSchemes: bwr, plasma

using Colors: RGB

using Test: @test

using BioLab

# ---- #

@test isconst(BioLab.Color, :HEFA)

@test BioLab.Color.HEFA === "#ebf6f7"

# ---- #

const HE_ = ("#ff71fb", "#fcc9b9", "#c91f37")

const CO = BioLab.Color._make_color_scheme(HE_)

@test length(CO) === length(HE_)

# ---- #

for co in (:COBW, :COPA, :COP3, :COAS, :COPL, :COBI, :COHU, :COST, :COMO)

    @test isconst(BioLab.Color, co)

end

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

    @test BioLab.Color._make_hex(rg, :RGB) ===
          BioLab.Color._make_hex(rg, :rgb) ===
          join(re[[1, 2, 4, 6]])

end

# ---- #

for he in ("#ff0000", "#00ff00", "#0000ff")

    for (al, re) in ((0, "00"), (0.5, "80"), (1, "ff"))

        @test BioLab.Color.add_alpha(he, al) === "$he$re"

    end

end

# ---- #

const N_ = (0, 1, 2, 3)

for n in N_

    @test BioLab.Color.pick_color_scheme(rand(n)) === BioLab.Color.COBW

end

# ---- #

for (n, re) in
    zip(N_, (BioLab.Color.COMO, BioLab.Color.COMO, BioLab.Color.COBI, BioLab.Color.COPL))

    @test BioLab.Color.pick_color_scheme(rand(Int, n)) === re

end

# ---- #

const N = length(CO)

for id in (-1, 0, N + 1)

    @test BioLab.Error.@is CO[id]

    @test BioLab.Color.color([id], CO) == [HE_[2]]

end

# ---- #

const ID_ = eachindex(HE_)

for (id, re) in zip(ID_, HE_)

    @test BioLab.Color.color(id, CO) === re

    @test BioLab.Color.color([id], CO) == [HE_[2]]

end

# ---- #

@test BioLab.Error.@is BioLab.Color.color(NaN, CO)

@test BioLab.Color.color([NaN], CO) == [HE_[2]]

# ---- #

for (fl, re) in zip(
    (-Inf, -0.1, 0.0, 0.01, 0.5, 0.99, 1.0, 1.1, Inf),
    (HE_[1], HE_[1], HE_[1], "#ff73fa", HE_[2], "#ca223a", HE_[3], HE_[3], HE_[3]),
)

    @test BioLab.Color.color(fl, CO) === re

    @test BioLab.Color.color([fl], CO) == [HE_[2]]

end

# ---- #

@test BioLab.Color.color(ID_, CO) == collect(HE_)

# ---- #

@test BioLab.Color.color(vcat(ID_, N + 1), CO) == [HE_[1], "#fdaccf", "#eb908e", HE_[end]]

# ---- #

for (he_, fr_) in (
    ((BioLab.Color.HEFA,), (0.5,)),
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
