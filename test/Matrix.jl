using Random: randstring, seed!

using StatsBase: mean

using Test: @test

using Nucleus

# ---- #

const IT_ = [4, 5, 6]

# ---- #

for (an___, ty, re) in (
    (([1, 2, 3], IT_), nothing, [1 2 3; 4 5 6]),
    (([1.0, 2, 3], IT_), Real, [1 2.0 3; 4 5 6]),
    (([1, nothing, 3], IT_), nothing, [1 nothing 3; 4 5 6]),
    (([1, missing, 3], IT_), nothing, [1 missing 3; 4 5 6]),
    (([1.0, NaN, 3.0], IT_), Real, [1 NaN 3; 4 5 6]),
    (([1.0, Inf, 3.0], IT_), Real, [1 Inf 3; 4 5 6]),
    (
        ([1, nothing, missing], [2, NaN, Inf]),
        Union{Nothing, Missing, Real},
        [1 nothing missing; 2 NaN Inf],
    ),
    (([1, nothing, missing], ["", NaN, Inf]), nothing, [1 nothing missing; "" NaN Inf]),
    ((['1', '2', '3'], ['4', '5', '6']), nothing, ['1' '2' '3'; '4' '5' '6']),
    ((["Aa", "Bb", "Cc"], ["Dd", "Ee", "Ff"]), nothing, ["Aa" "Bb" "Cc"; "Dd" "Ee" "Ff"]),
    ((['1', '2', '3'], ["Dd", "Ee", "Ff"]), Any, ['1' '2' '3'; "Dd" "Ee" "Ff"]),
)

    if isnothing(ty)

        ty = eltype(re)

    end

    ma = Nucleus.Matrix.make(an___)

    @test eltype(ma) == ty

    @test isequal(ma, re)

    # 23.929 ns (1 allocation: 112 bytes)
    # 73.826 ns (5 allocations: 256 bytes)
    # 63.540 ns (2 allocations: 224 bytes)
    # 63.053 ns (2 allocations: 224 bytes)
    # 75.403 ns (5 allocations: 256 bytes)
    # 75.352 ns (5 allocations: 256 bytes)
    # 577.410 ns (17 allocations: 880 bytes)
    # 225.091 ns (7 allocations: 432 bytes)
    # 23.636 ns (1 allocation: 80 bytes)
    # 33.493 ns (1 allocation: 96 bytes)
    # 63.265 ns (2 allocations: 176 bytes)
    #@btime Nucleus.Matrix.make($an___)

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

        @test Nucleus.Error.@is Nucleus.Matrix.collapse(mean, Float64, ro_, MA)

    else

        @test Nucleus.Matrix.collapse(mean, Float64, ro_, MA) == (roc_, mac)

        # 743.345 ns (19 allocations: 1.28 KiB)
        # 659.544 ns (15 allocations: 1.08 KiB)
        #@btime Nucleus.Matrix.collapse(mean, Float64, $ro_, MA)

    end

end

# ---- #

const CH_ = ('A', 'B', 'C', 'D', 'E', 'F', 'G')

# ---- #

for n in (100, 1000, 10000, 20000)

    seed!(20230920)

    # 29.959 μs (375 allocations: 127.28 KiB)
    # 3.002 ms (1797 allocations: 11.92 MiB)
    # 605.107 ms (2770 allocations: 815.50 MiB)
    # 2.437 s (3103 allocations: 3.08 GiB)
    #@btime Nucleus.Matrix.collapse(
    #    mean,
    #    Float64,
    #    $([randstring(CH_, 3) for _ in 1:n]),
    #    $(rand(n, n)),
    #)

end
