using Random: randstring, seed!

using StatsBase: mean

using Test: @test

using Omics

# ---- #

# 15.708 μs (22 allocations: 2.03 KiB)

for (vt_, vf, mi, re) in (([1, 2, 1, 2], rand(1000, 4), 1.0, trues(1000)),)

    @test Omics.XSample.select_non_nan(vt_, vf, mi) == re

    #@btime Omics.XSample.select_non_nan($vt_, $vf, $mi)

end

# ---- #

const V1 = [
    1 2
    10 20
    100 200
]

for (f1_, re) in (
    (["R1", "R1", "R2"], (
        ["R1", "R2"],
        [
            5.5 11
            100 200
        ],
    )),
    (["R1", "R1", "R1"], (["R1"], [37.0 74])),
)

    @test Omics.XSample.collapse(mean, Float64, f1_, V1) == re

end

# ---- #

# 26.500 μs (478 allocations: 187.80 KiB)

for ur in (100,)

    seed!(20230920)

    #@btime Omics.XSample.collapse(
    #    mean,
    #    Float64,
    #    $([randstring('A':'G', 3) for _ in 1:ur]),
    #    $(rand(ur, ur)),
    #)

end

# ---- #

# 5.792 μs (0 allocations: 0 bytes)

seed!(20250123)

for vf in (rand(100, 10),)

    #@btime Omics.XSample.shift_log2!($vf)

end

# ---- #

# 711.029 ns (22 allocations: 2.02 KiB)
# 703.199 ns (22 allocations: 1.97 KiB)
# 712.475 ns (22 allocations: 1.95 KiB)
# 680.099 ns (22 allocations: 1.92 KiB)

for (fi, f1_, s1_, v1, f2_, s2_, v2, re) in (
    (
        0,
        ["R1", "R2"],
        ["C1", "C2", "C3"],
        [
            1 3 5
            2 4 6
        ],
        ["R3", "R4"],
        ["C4", "C5", "C6"],
        [
            7 9 11
            8 10 12
        ],
        (
            ["R1", "R2", "R3", "R4"],
            ["C1", "C2", "C3", "C4", "C5", "C6"],
            [
                1 3 5 0 0 0
                2 4 6 0 0 0
                0 0 0 7 9 11
                0 0 0 8 10 12
            ],
        ),
    ),
    (
        0,
        ["R1", "R2"],
        ["C1", "C2", "C3"],
        [
            1 3 5
            2 4 6
        ],
        ["R2", "R3"],
        ["C4", "C5", "C6"],
        [
            7 9 11
            8 10 12
        ],
        (
            ["R1", "R2", "R3"],
            ["C1", "C2", "C3", "C4", "C5", "C6"],
            [
                1 3 5 0 0 0
                2 4 6 7 9 11
                0 0 0 8 10 12
            ],
        ),
    ),
    (
        0,
        ["R1", "R2"],
        ["C1", "C2", "C3"],
        [
            1 3 5
            2 4 6
        ],
        ["R3", "R4"],
        ["C2", "C3", "C4"],
        [
            7 9 11
            8 10 12
        ],
        (
            ["R1", "R2", "R3", "R4"],
            ["C1", "C2", "C3", "C4"],
            [
                1 3 5 0
                2 4 6 0
                0 7 9 11
                0 8 10 12
            ],
        ),
    ),
    (
        0,
        ["R1", "R2"],
        ["C1", "C2", "C3"],
        [
            1 3 5
            2 4 6
        ],
        ["R2", "R3"],
        ["C2", "C3", "C4"],
        [
            7 9 11
            8 10 12
        ],
        (
            ["R1", "R2", "R3"],
            ["C1", "C2", "C3", "C4"],
            [
                1 3 5 0
                2 7 9 11
                0 8 10 12
            ],
        ),
    ),
)

    @test Omics.XSample.joi(fi, f1_, s1_, v1, f2_, s2_, v2) == re

    #@btime Omics.XSample.joi($fi, $f1_, $s1_, $v1, $f2_, $s2_, $v2)

end
