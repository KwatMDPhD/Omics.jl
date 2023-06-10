include("environment.jl")

# ---- #

@test @is_error BioLab.Matrix.make(([1, 2], [3, 4, 5]))

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

    # @test isequal(BioLab.Matrix.make(an___), re)

    # 56.614 ns (2 allocations: 224 bytes)
    # 86.618 ns (2 allocations: 224 bytes)
    # 86.143 ns (2 allocations: 224 bytes)
    # 1.233 μs (15 allocations: 528 bytes)
    # 815.126 ns (15 allocations: 528 bytes)
    # 3.917 μs (9 allocations: 400 bytes)
    # 83.593 ns (2 allocations: 160 bytes)
    # 2.773 μs (43 allocations: 1.33 KiB)
    # @btime BioLab.Matrix.make($an___);

end
