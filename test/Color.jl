using LeMoColor

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

@test LeMoColor._hexify(LeMoColor._parse("red")) === "#ff0000"

# ---- #

for (al, re) in ((0, "#00000000"), (0.5, "#00000080"), (1, "#000000ff"))

    @test LeMoColor.fade("#000000", al) === LeMoColor.fade("#00000000", al) === re

end

# ---- #

const CO = LeMoColor.make(["#ff0000", "#00ff00", "#0000ff"])

# ---- #

@test LeMoColor.pick(Float64[]) === LeMoColor.bwr

for (uc, re) in ((1, LeMoColor.MO), (2, LeMoColor.BI), (3, LeMoColor.CA))

    @test LeMoColor.pick(rand(Int, uc)) === re

end

# ---- #

for (nu, re) in (
    # Indexed.
    (1, "#ff0000"),
    (2, "#00ff00"),
    (3, "#0000ff"),
    # Normalized between 0 and 1.
    (-Inf, "#ff0000"),
    (-0.1, "#ff0000"),
    (0.0, "#ff0000"),
    (0.01, "#fa0500"),
    (0.5, "#00ff00"),
    (0.99, "#0005fa"),
    (1.0, "#0000ff"),
    (1.1, "#0000ff"),
    (Inf, "#0000ff"),
)

    @test LeMoColor.color(nu, CO) === re

end

# ---- #

for (nu_, re) in (
    # Normalized between the extrema.
    ([NaN], ["#00ff00"]),
    ([-1], ["#00ff00"]),
    ([0], ["#00ff00"]),
    ([4], ["#00ff00"]),
    (1:3, ["#ff0000", "#00ff00", "#0000ff"]),
    (1:4, ["#ff0000", "#55aa00", "#00aa55", "#0000ff"]),
)

    @test LeMoColor.color(nu_, CO) == re

end

# ---- #

for he_ in (
    ["#000001"],
    ["#000001", "#000002"],
    ["#000001", "#000002", "#000003"],
    ["#000001", "#000002", "#000003", "#000004"],
    ["#000001", "#000002", "#000003", "#000004", "#000005"],
    ["#000001", "#000002", "#000003", "#000004", "#000005", "#000006"],
)

    co = LeMoColor.make(he_)

    LeMoColor.fractionate(co)

    # 179.243 ns (8 allocations: 392 bytes)
    # 379.063 ns (14 allocations: 624 bytes)
    # 527.562 ns (20 allocations: 888 bytes)
    # 661.012 ns (26 allocations: 1.11 KiB)
    # 801.646 ns (32 allocations: 1.37 KiB)
    # 930.129 ns (38 allocations: 1.61 KiB)
    #@btime LeMoColor.fractionate($co)

end
