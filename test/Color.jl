using Test: @test

using Nucleus

# ---- #

using Colors: RGB

# ---- #

const HE_ = ["#ff0000", "#00ff00", "#0000ff"]

# ---- #

const CO = Nucleus.Color._make_color_scheme(HE_)

# ---- #

const N = lastindex(CO)

# ---- #

@test N === lastindex(HE_)

# ---- #

for co in (
    Nucleus.Color._make_color_scheme([
        Nucleus.Color.HEFA,
        Nucleus.Color.HEAG,
        Nucleus.Color.HEAY,
        Nucleus.Color.HERE,
        Nucleus.Color.HEGR,
        Nucleus.Color.HEBL,
        Nucleus.Color.HESR,
        Nucleus.Color.HESG,
        Nucleus.Color.HEGE,
        Nucleus.Color.HEGP,
    ]),
    Nucleus.Color.COAS,
    Nucleus.Color.COBW,
    Nucleus.Color.COPA,
    Nucleus.Color.COMO,
    Nucleus.Color.COBI,
    Nucleus.Color.COPO,
)

    Nucleus.Plot.plot_heat_map(
        "",
        Matrix(reshape(1:lastindex(co), 1, :));
        text = [Nucleus.Color._hexify(rg) for _ in 1:1, rg in co.colors],
        co,
    )

end

# ---- #

for (rg, re) in zip((RGB(1, 0, 0), RGB(0, 1, 0), RGB(0, 0, 1)), HE_)

    @test Nucleus.Color._hexify(rg) === re

end

# ---- #

for he in HE_, (al, re) in ((0, "00"), (0.5, "80"), (1, "ff"))

    @test Nucleus.Color.add_alpha(he, al) === "$he$re"

end

# ---- #

for (n, re) in (
    (0, Nucleus.Color.COMO),
    (1, Nucleus.Color.COMO),
    (2, Nucleus.Color.COBI),
    (3, Nucleus.Color.COPO),
)

    @test Nucleus.Color.pick_color_scheme(rand(Int, n)) === re

    @test Nucleus.Color.pick_color_scheme(rand(n)) === Nucleus.Color.COBW

end

# ---- #

const HEH = HE_[Int(round(0.5N))]

# ---- #

for id in (-1, 0, N + 1)

    @test Nucleus.Error.@is CO[id]

    @test Nucleus.Color.color([id], CO) == [HEH]

end

# ---- #

const ID_ = collect(1:N)

# ---- #

for (id, re) in zip(ID_, HE_)

    @test Nucleus.Color.color(id, CO) === re

    @test Nucleus.Color.color([id], CO) == [HEH]

end

# ---- #

@test Nucleus.Error.@is Nucleus.Color.color(NaN, CO)

# ---- #

@test Nucleus.Color.color([NaN], CO) == [HEH]

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

    @test Nucleus.Color.color(fl, CO) === re

    @test Nucleus.Color.color([fl], CO) == [HEH]

end

# ---- #

@test Nucleus.Color.color(ID_, CO) == HE_

# ---- #

@test Nucleus.Color.color(vcat(ID_, N + 1), CO) == [HE_[1], "#55aa00", "#00aa55", HE_[N]]

# ---- #

# 644.442 ns (25 allocations: 1.29 KiB)
#@btime Nucleus.Color.color(ID_, CO);

# ---- #

for he_ in (
    ["#000001"],
    ["#000001", "#000002"],
    ["#000001", "#000002", "#000003"],
    ["#000001", "#000002", "#000003", "#000004"],
    ["#000001", "#000002", "#000003", "#000004", "#000005"],
    ["#000001", "#000002", "#000003", "#000004", "#000005", "#000006"],
)

    co = Nucleus.Color._make_color_scheme(he_)

    if isone(lastindex(he_))

        push!(he_, he_[1])

    end

    @test Nucleus.Color.fractionate(co) == collect(zip(range(0, 1, lastindex(he_)), he_))

    # 320.566 ns (11 allocations: 552 bytes)
    # 472.362 ns (17 allocations: 720 bytes)
    # 649.242 ns (24 allocations: 1016 bytes)
    # 807.471 ns (31 allocations: 1.25 KiB)
    # 973.059 ns (38 allocations: 1.54 KiB)
    # 1.133 μs (45 allocations: 1.80 KiB)
    #@btime Nucleus.Color.fractionate($co)

end
