using Random: seed!

using StatsBase: mean

using Test: @test

using BioLab

# ---- #

for (an___, re) in (
    (([1, 2, 3], [4, 5, 6]), [1 2 3; 4 5 6]),
    (([1, 2.0, 3], [4, 5, 6]), [1 2.0 3; 4 5 6]),
    (([1, NaN, 3], [4, 5, 6]), [1 NaN 3; 4 5 6]),
    (([1, nothing, 3], [4, 5, 6]), [1 nothing 3; 4 5 6]),
    (([1, missing, 3], [4, 5, 6]), [1 missing 3; 4 5 6]),
    (([1, nothing, 3], [missing, 4, 5], [7, 8, NaN]), [1 nothing 3; missing 4 5; 7 8 NaN]),
    ((['1', '2', '3'], ['4', '5', '6']), ['1' '2' '3'; '4' '5' '6']),
    (
        (
            [missing, 1, 2, 3],
            [nothing, 2, 3, 4],
            [Inf, 3, 4, 5],
            [-Inf, 4, 5, 6],
            [missing, nothing, Inf, -Inf],
            ['a', 'b', 'c', 'd'],
        ),
        [
            missing 1 2 3
            nothing 2 3 4
            Inf 3 4 5
            -Inf 4 5 6
            missing nothing Inf -Inf
            'a' 'b' 'c' 'd'
        ],
    ),
)

    @test isequal(BioLab.Matrix.make(an___), re)

    # 23.929 ns (1 allocation: 112 bytes)
    # 75.394 ns (5 allocations: 256 bytes)
    # 75.360 ns (5 allocations: 256 bytes)
    # 64.479 ns (2 allocations: 224 bytes)
    # 63.350 ns (2 allocations: 224 bytes)
    # 730.916 ns (17 allocations: 1008 bytes)
    # 23.636 ns (1 allocation: 80 bytes)
    # 1.283 μs (25 allocations: 1.34 KiB)
    @btime BioLab.Matrix.make($an___)

end

# ---- #

const MA = [
    1 2
    10 20
    100 200
]

# ---- #

disable_logging(Info)

# ---- #

for (ro_, ro2_, ma2) in (
    (["Row 1", "Row 2", "Row 3"], nothing, nothing),
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

    if isnothing(ro2_)

        # There are not any rows to collapse.
        @test isnothing(BioLab.Matrix.collapse(mean, Float64, ro_, MA))

    else

        @test BioLab.Matrix.collapse(mean, Float64, ro_, MA) == (ro2_, ma2)

        # 753.915 ns (19 allocations: 1.31 KiB)
        # 646.598 ns (15 allocations: 1.08 KiB)
        @btime BioLab.Matrix.collapse(mean, Float64, $ro_, $MA)

    end

end

# ---- #

for n in (100, 1000, 10000, 20000)

    seed!(20230920)

    ro_ = [join(rand('A':'G', 3)) for _ in 1:n]

    ma = rand(n, n)

    BioLab.Matrix.collapse(mean, Float64, ro_, ma)

    # 32.417 μs (375 allocations: 186.91 KiB)
    # 3.103 ms (1797 allocations: 12.35 MiB)
    # 566.602 ms (2770 allocations: 815.50 MiB)
    # 2.343 s (3103 allocations: 3.08 GiB)
    @btime BioLab.Matrix.collapse(mean, Float64, $ro_, $ma)

end
