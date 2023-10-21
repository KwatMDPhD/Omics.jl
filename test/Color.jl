using Colors: RGB

using Test: @test

using BioLab

# ---- #

const HE_ = ["#ff0000", "#00ff00", "#0000ff"]

# ---- #

const CO = BioLab.Color._make_color_scheme(HE_)

# ---- #

const N = lastindex(CO)

# ---- #

@test N === lastindex(HE_)

# ---- #

for co in (
    BioLab.Color._make_color_scheme([
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
        Matrix(reshape(1:lastindex(co), 1, :));
        text = [BioLab.Color._hexify(rg) for _ in 1:1, rg in co.colors],
        co,
    )

end

# ---- #

for (rg, re) in zip((RGB(1, 0, 0), RGB(0, 1, 0), RGB(0, 0, 1)), HE_)

    @test BioLab.Color._hexify(rg) === re

end

# ---- #

for he in HE_, (al, re) in ((0, "00"), (0.5, "80"), (1, "ff"))

    @test BioLab.Color.add_alpha(he, al) === "$he$re"

end

# ---- #

for (n, re) in (
    (0, BioLab.Color.COMO),
    (1, BioLab.Color.COMO),
    (2, BioLab.Color.COBI),
    (3, BioLab.Color.COPO),
)

    @test BioLab.Color.pick_color_scheme(rand(Int, n)) === re

    @test BioLab.Color.pick_color_scheme(rand(n)) === BioLab.Color.COBW

end

# ---- #

const HEH = HE_[Int(round(0.5N))]

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

for (fl, re) in (
    (-Inf, HE_[1]),
    (-0.1, HE_[1]),
    (0.0, HE_[1]),
    (0.01, "#fa0500"),
    (0.5, HEH),
    (0.99, "#0005fa"),
    (1.0, HE_[N]),
    (1.1, HE_[N]),
    (Inf, HE_[N]),
)

    @test BioLab.Color.color(fl, CO) === re

    @test BioLab.Color.color([fl], CO) == [HEH]

end

# ---- #

@test BioLab.Color.color(ID_, CO) == HE_

# ---- #

@test BioLab.Color.color(vcat(ID_, N + 1), CO) == [HE_[1], "#55aa00", "#00aa55", HE_[N]]

# ---- #

# 644.442 ns (25 allocations: 1.29 KiB)
#@btime BioLab.Color.color(ID_, CO);

# ---- #

for he_ in (
    ["#000001"],
    ["#000001", "#000002"],
    ["#000001", "#000002", "#000003"],
    ["#000001", "#000002", "#000003", "#000004"],
    ["#000001", "#000002", "#000003", "#000004", "#000005"],
    ["#000001", "#000002", "#000003", "#000004", "#000005", "#000006"],
)

    co = BioLab.Color._make_color_scheme(he_)

    if isone(lastindex(he_))

        push!(he_, he_[1])

    end

    @test BioLab.Color.fractionate(co) == collect(zip(range(0, 1, lastindex(he_)), he_))

    # 320.566 ns (11 allocations: 552 bytes)
    # 472.362 ns (17 allocations: 720 bytes)
    # 649.242 ns (24 allocations: 1016 bytes)
    # 807.471 ns (31 allocations: 1.25 KiB)
    # 973.059 ns (38 allocations: 1.54 KiB)
    # 1.133 μs (45 allocations: 1.80 KiB)
    #@btime BioLab.Color.fractionate($co)

end
