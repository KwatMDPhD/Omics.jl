using Colors: RGB

using Test: @test

using BioLab

# ---- #

const HE_ = ["#ff0000", "#00ff00", "#0000ff"]

# ---- #

const CO = BioLab.Color._co(HE_)

# ---- #

const N = length(CO)

# ---- #

@test N === length(HE_)

# ---- #

for co in (
    BioLab.Color._co([
        BioLab.Color.HEFA,
        BioLab.Color.HEAG,
        BioLab.Color.HEAY,
        BioLab.Color.HEBL,
        BioLab.Color.HERE,
        BioLab.Color.HESR,
        BioLab.Color.HESG,
    ]),
    BioLab.Color.COAS,
    BioLab.Color.COBW,
    BioLab.Color.COPA,
    BioLab.Color.COMO,
    BioLab.Color.COBI,
    BioLab.Color.COPO,
)

    BioLab.Plot.plot_heat_map(
        "",
        Matrix(reshape(1:length(co), 1, :));
        text = [BioLab.Color._he(rg) for _ in 1:1, rg in co.colors],
        co,
    )

end

# ---- #

for (rg, re) in zip((RGB(1, 0, 0), RGB(0, 1, 0), RGB(0, 0, 1)), HE_)

    @test BioLab.Color._he(rg) === re

end

# ---- #

for he in HE_, (al, re) in ((0, "00"), (0.5, "80"), (1, "ff"))

    @test BioLab.Color.add_alpha(he, al) === "$he$re"

end

# ---- #

const N_ = (0, 1, 2, 3)

# ---- #

for n in N_

    @test BioLab.Color.pick_color_scheme(rand(n)) === BioLab.Color.COBW

end

# ---- #

for (n, re) in
    zip(N_, (BioLab.Color.COMO, BioLab.Color.COMO, BioLab.Color.COBI, BioLab.Color.COPO))

    @test BioLab.Color.pick_color_scheme(rand(Int, n)) === re

end

# ---- #

const HEH = HE_[Int(round(N / 2))]

# ---- #

for id in (-1, 0, N + 1)

    @test BioLab.Error.@is CO[id]

    @test BioLab.Color.color([id], CO) == [HEH]

end

# ---- #

const ID_ = collect(1:N)

# ---- #

for (id, re) in zip(ID_, HE_)

    @test BioLab.Color.color(id, CO) === re

    @test BioLab.Color.color([id], CO) == [HEH]

end

# ---- #

@test BioLab.Error.@is BioLab.Color.color(NaN, CO)

# ---- #

@test BioLab.Color.color([NaN], CO) == [HEH]

# ---- #

for (fl, re) in zip(
    (-Inf, -0.1, 0.0, 0.01, 0.5, 0.99, 1.0, 1.1, Inf),
    (HE_[1], HE_[1], HE_[1], "#fa0500", HEH, "#0005fa", HE_[N], HE_[N], HE_[N]),
)

    @test BioLab.Color.color(fl, CO) === re

    @test BioLab.Color.color([fl], CO) == [HEH]

end

# ---- #

@test BioLab.Color.color(ID_, CO) == HE_

# ---- #

@test BioLab.Color.color(vcat(ID_, N + 1), CO) == [HE_[1], "#55aa00", "#00aa55", HE_[N]]

# ---- #

# 607.244 ns (25 allocations: 1.29 KiB)
@btime BioLab.Color.color(ID_, CO);

# ---- #

for (he_, fr_) in (
    (["#000001"], (0.0, 1.0)),
    (["#000001", "#000002"], (0.0, 1.0)),
    (["#000001", "#000002", "#000003"], (0.0, 0.5, 1.0)),
    (["#000001", "#000002", "#000003", "#000004"], (0.0, 1 / 3, 2 / 3, 1.0)),
    (["#000001", "#000002", "#000003", "#000004", "#000005"], (0.0, 0.25, 0.5, 0.75, 1.0)),
    (
        ["#000001", "#000002", "#000003", "#000004", "#000005", "#000006"],
        (0, 0.2, 0.4, 0.6, 0.8, 1),
    ),
)

    co = BioLab.Color._co(he_)

    if isone(length(he_))

        push!(he_, he_[1])

    end

    @test BioLab.Color.fractionate(co) == collect(zip(fr_, he_))

    # 337.521 ns (11 allocations: 552 bytes)
    # 475.210 ns (17 allocations: 720 bytes)
    # 646.085 ns (24 allocations: 1016 bytes)
    # 794.737 ns (31 allocations: 1.25 KiB)
    # 944.429 ns (38 allocations: 1.54 KiB)
    # 1.100 μs (45 allocations: 1.80 KiB)
    @btime BioLab.Color.fractionate($co)

end
