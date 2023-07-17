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

    # 22.734 ns (1 allocation: 96 bytes)
    # 23.845 ns (1 allocation: 112 bytes)
    # 75.309 ns (5 allocations: 256 bytes)
    # 75.283 ns (5 allocations: 256 bytes)
    # 64.584 ns (2 allocations: 224 bytes)
    # 62.926 ns (2 allocations: 224 bytes)
    # 722.793 ns (17 allocations: 1008 bytes)
    # 23.678 ns (1 allocation: 80 bytes)
    # 1.396 μs (25 allocations: 1.34 KiB)
    @btime BioLab.Matrix.make($an___)

end
