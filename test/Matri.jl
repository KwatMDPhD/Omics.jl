using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Random: randstring, seed!

using StatsBase: mean

# ---- #

const MA = [
    1 2
    10 20
    100 200
]

for (ro_, r2_, m2) in (
    (
        ["Row 1", "Row 1", "Row 2"],
        ["Row 1", "Row 2"],
        [
            5.5 11
            100 200
        ],
    ),
    (["Row 1", "Row 1", "Row 1"], ["Row 1"], [37.0 74]),
)

    @test Omics.Matri.collapse(mean, Float64, ro_, MA) == (r2_, m2)

end

# ---- #

# 26.500 μs (480 allocations: 188.55 KiB)
# 2.754 ms (2818 allocations: 12.36 MiB)
for ur in (100, 1000)

    seed!(20230920)

    @btime Omics.Matri.collapse(
        mean,
        Float64,
        $([randstring('A':'G', 3) for _ in 1:ur]),
        $(rand(ur, ur)),
    )

end

# ---- #

# 813.253 ns (22 allocations: 2.02 KiB)
# 798.177 ns (22 allocations: 1.97 KiB)
# 788.957 ns (22 allocations: 1.95 KiB)
# 756.060 ns (22 allocations: 1.92 KiB)
for (fi, r1_, c1_, a1, r2_, c2_, a2, re) in (
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

    @test Omics.Matri.joi(fi, r1_, c1_, a1, r2_, c2_, a2) == re

    @btime Omics.Matri.joi($fi, $r1_, $c1_, $a1, $r2_, $c2_, $a2)

end
