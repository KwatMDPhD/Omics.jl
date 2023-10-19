using Random: seed!

using StatsBase: mean

using Test: @test

using BioLab

# ---- #

for (an___, re) in (
    (([1, 2, 3], [4, 5, 6]), [1 2 3; 4 5 6]),
    (([1, 2.0, 3], [4, 5, 6]), [1 2.0 3; 4 5 6]),
    (([1, nothing, 3], [4, 5, 6]), [1 nothing 3; 4 5 6]),
    (([1, missing, 3], [4, 5, 6]), [1 missing 3; 4 5 6]),
    (([1, NaN, 3], [4, 5, 6]), [1 NaN 3; 4 5 6]),
    (([1, -Inf, 3], [4, 5, 6]), [1 -Inf 3; 4 5 6]),
    (([1, Inf, 3], [4, 5, 6]), [1 Inf 3; 4 5 6]),
    (([1, nothing, missing], [NaN, -Inf, Inf]), [1 nothing missing; NaN -Inf Inf]),
    ((['1', '2', '3'], ['4', '5', '6']), ['1' '2' '3'; '4' '5' '6']),
    ((["Aa", "Bb", "Cc"], ["Dd", "Ee", "Ff"]), ["Aa" "Bb" "Cc"; "Dd" "Ee" "Ff"]),
    ((['1', '2', '3'], ["Dd", "Ee", "Ff"]), ['1' '2' '3'; "Dd" "Ee" "Ff"]),
)

    @test isequal(BioLab.Matrix.make(an___), re)

    # 24.054 ns (1 allocation: 112 bytes)
    # 75.275 ns (5 allocations: 256 bytes)
    # 63.010 ns (2 allocations: 224 bytes)
    # 62.988 ns (2 allocations: 224 bytes)
    # 73.741 ns (5 allocations: 256 bytes)
    # 75.266 ns (5 allocations: 256 bytes)
    # 75.309 ns (5 allocations: 256 bytes)
    # 544.561 ns (17 allocations: 880 bytes)
    # 23.720 ns (1 allocation: 80 bytes)
    # 33.492 ns (1 allocation: 96 bytes)
    # 63.733 ns (2 allocations: 176 bytes)
    #@btime BioLab.Matrix.make($an___)

end

# ---- #

const MA = [
    1 2
    10 20
    100 200
]

# ---- #

#disable_logging(Info)

# ---- #

for (ro_, roc_, mac) in (
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

    if isnothing(roc_)

        @test BioLab.Error.@is BioLab.Matrix.collapse(mean, Float64, ro_, MA)

    else

        @test BioLab.Matrix.collapse(mean, Float64, ro_, MA) == (roc_, mac)

        # 752.855 ns (18 allocations: 1.23 KiB)
        # 614.460 ns (15 allocations: 1.02 KiB)
        #@btime BioLab.Matrix.collapse(mean, Float64, $ro_, MA)

    end

end

# ---- #

for n in (100, 1000, 10000, 20000)

    seed!(20230920)

    # 29.041 μs (375 allocations: 127.28 KiB)
    # 2.913 ms (1797 allocations: 11.92 MiB)
    # 576.514 ms (2770 allocations: 815.50 MiB)
    # 2.391 s (3103 allocations: 3.08 GiB)
    #@btime BioLab.Matrix.collapse(
    #    mean,
    #    Float64,
    #    $([join(rand('A':'G', 3)) for _ in 1:n]),
    #    $(rand(n, n)),
    #)

end
