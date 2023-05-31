include("environment.jl")

# ---- #

@test @is_error BioLab.Matrix.print(Matrix())

for (n_ro, n_co) in ((2, 2), (4, 2), (2, 4), (4, 4), (6, 6), (10, 10))

    BioLab.print_header("$n_ro x $n_co")

    ro_x_co_x_an = BioLab.Matrix.simulate(n_ro, n_co, "1.0:")

    BioLab.Matrix.print(ro_x_co_x_an)

    # @code_warntype BioLab.Matrix.print(ro_x_co_x_an)

end

# ---- #

@test !@is_error BioLab.Matrix.error_bad(["a" "b"; "c" "d"], String)

@test !@is_error BioLab.Matrix.error_bad([1 2; 3 4], Real)

@test @is_error BioLab.Matrix.error_bad(["a" ""; "c" "d"], String)

for ba in (Inf, -Inf, NaN)

    @test @is_error BioLab.Matrix.error_bad([1 ba; 3 4], Real)

end

ba___ = (
    [missing, 1, 2, 3],
    [nothing, 2, 3, 4],
    [Inf, 3, 4, 5],
    [-Inf, 4, 5, 6],
    [missing, nothing, Inf, -Inf],
    ["a", "b", "c", "d"],
)

ro_x_co_x_ba = BioLab.Matrix.make(ba___)

@test @is_error BioLab.Matrix.error_bad(ro_x_co_x_ba, Real)

# @code_warntype BioLab.Matrix.error_bad(ro_x_co_x_ba, Real)

# ---- #

@test @is_error BioLab.Matrix.make(([1, 2], [3, 4, 5]))

for an___ in (
    ([1, 2, 3], [4, 5, 6]),
    ([1, 2.0, 3], [4, 5, 6]),
    ([1, NaN, 3], [4, 5, 6]),
    ([1, nothing, 3], [4, 5, 6]),
    ([1, missing, 3], [4, 5, 6]),
    ([1, nothing, 3], [missing, 4, 5], [7, 8, NaN]),
    (['1', '2', '3'], ['4', '5', '6']),
    ba___,
)

    BioLab.print_header(an___)

    # TODO: `@test`.
    display(BioLab.Matrix.make(an___))

    # @code_warntype BioLab.Matrix.make(an___)

    # 78.479 ns (2 allocations: 224 bytes)
    # 90.300 ns (2 allocations: 224 bytes)
    # 90.553 ns (2 allocations: 224 bytes)
    # 129.269 ns (2 allocations: 224 bytes)
    # 126.810 ns (2 allocations: 224 bytes)
    # 2.787 μs (9 allocations: 400 bytes)
    # 76.411 ns (2 allocations: 160 bytes)
    # 1.995 μs (28 allocations: 992 bytes)
    # @btime BioLab.Matrix.make($an___)

end

# ---- #

ro_x_co_x_an = [
    1.0 10 100
    2 20 200
    3 30 300
]

display(ro_x_co_x_an)

function fu!(nu_)

    ma = maximum(nu_)

    for id in eachindex(nu_)

        nu_[id] += ma

    end

    return nothing

end

# ---- #

co = copy(ro_x_co_x_an)

BioLab.Matrix.apply_by_column!(fu!, co)

@test isequal(
    co,
    [
        4.0 40 400
           5 50 500
           6 60 600
    ],
)

# @code_warntype BioLab.Matrix.apply_by_column!(fu!, co)

# 54.078 ns (0 allocations: 0 bytes)
# @btime BioLab.Matrix.apply_by_column!($fu!, $co) setup = (co = copy($ro_x_co_x_an))

# ---- #

co = copy(ro_x_co_x_an)

BioLab.Matrix.apply_by_row!(fu!, co)

@test isequal(
    co,
    [
         101.0 110 200
        202 220 400
        303 330 600
    ],
)

# @code_warntype BioLab.Matrix.apply_by_row!(fu!, co)

# 53.963 ns (0 allocations: 0 bytes)
# @btime BioLab.Matrix.apply_by_row!($fu!, $co) setup = (co = copy($ro_x_co_x_an))

# ---- #

n_ro = 2

n_co = 3

for ho in ("1.0:", "rand")

    BioLab.print_header(ho)

    # TODO: `@test`.
    display(BioLab.Matrix.simulate(n_ro, n_co, ho))

    # @code_warntype BioLab.Matrix.simulate(n_ro, n_co, ho)

    # 147.837 ns (1 allocation: 112 bytes)
    # 63.436 ns (1 allocation: 112 bytes)
    # @btime BioLab.Matrix.simulate($n_ro, $n_co, $ho)

end
