using Test: @test

using BioLab

# ---- #

for (an___, re) in (
    (([1, 2], [3, 4, 5]), [1 2; 3 4]),
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

    # 24.054 ns (1 allocation: 96 bytes)
    # 25.645 ns (1 allocation: 112 bytes)
    # 74.554 ns (5 allocations: 256 bytes)
    # 74.512 ns (5 allocations: 256 bytes)
    # 63.052 ns (2 allocations: 224 bytes)
    # 63.095 ns (2 allocations: 224 bytes)
    # 715.850 ns (17 allocations: 1.05 KiB)
    # 25.560 ns (1 allocation: 80 bytes)
    # 2.167 μs (25 allocations: 1.41 KiB)
    @btime BioLab.Matrix.make($an___)

end
