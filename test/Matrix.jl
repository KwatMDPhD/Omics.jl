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

    @test isequal(BioLab.Matrix.make(an___), re)

end
