using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Random: randstring, seed!

using StatsBase: mean

# ---- #

Omics.FeatureBySample.get_sample

# ---- #

Omics.FeatureBySample.index_feature

# ---- #

Omics.FeatureBySample.select

# ---- #

const DA = [
    1 2
    10 20
    100 200
]

for (fe_, re) in (
    (["Row 1", "Row 1", "Row 2"], (
        ["Row 1", "Row 2"],
        [
            5.5 11
            100 200
        ],
    )),
    (["Row 1", "Row 1", "Row 1"], (["Row 1"], [37.0 74])),
)

    @test Omics.FeatureBySample.collapse(mean, Float64, fe_, DA) == re

end

# ---- #

# 26.625 μs (478 allocations: 187.80 KiB)
# 2.777 ms (2815 allocations: 12.36 MiB)
for ur in (100, 1000)

    seed!(20230920)

    #@btime Omics.FeatureBySample.collapse(
    #    mean,
    #    Float64,
    #    $([randstring('A':'G', 3) for _ in 1:ur]),
    #    $(rand(ur, ur)),
    #)

end

# ---- #

Omics.FeatureBySample.rea

# ---- #

# 964.286 ns (22 allocations: 2.02 KiB)
# 938.320 ns (22 allocations: 1.97 KiB)
# 916.675 ns (22 allocations: 1.95 KiB)
# 876.694 ns (22 allocations: 1.92 KiB)
for (fi, f1_, s1_, d1, f2_, s2_, d2, re) in (
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

    @test Omics.FeatureBySample.joi(fi, f1_, s1_, d1, f2_, s2_, d2) == re

    #@btime Omics.FeatureBySample.joi($fi, $f1_, $s1_, $d1, $f2_, $s2_, $d2)

end
