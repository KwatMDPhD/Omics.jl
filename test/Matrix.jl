using Random: seed!

using StatsBase: mean

using Test: @test

using BioLab

# ---- #

const TU = (4, 5, 6)

# ---- #

const VE = collect(TU)

# ---- #

for (an___, ty, re) in (
    (((1, 2, 3), TU), nothing, [1 2 3; 4 5 6]),
    (([1, 2, 3], VE), nothing, [1 2 3; 4 5 6]),
    (((1.0, 2.0, 3.0), TU), Matrix{Real}, [1 2.0 3; 4 5 6]),
    (([1.0, 2, 3], VE), Matrix{Real}, [1 2.0 3; 4 5 6]),
    (((1, nothing, 3), TU), nothing, [1 nothing 3; 4 5 6]),
    (([1, nothing, 3], VE), nothing, [1 nothing 3; 4 5 6]),
    (((1, missing, 3), TU), nothing, [1 missing 3; 4 5 6]),
    (([1, missing, 3], VE), nothing, [1 missing 3; 4 5 6]),
    (((1.0, NaN, 3.0), TU), Matrix{Real}, [1 NaN 3; 4 5 6]),
    (([1.0, NaN, 3.0], VE), Matrix{Real}, [1 NaN 3; 4 5 6]),
    (((1.0, Inf, 3.0), TU), Matrix{Real}, [1 Inf 3; 4 5 6]),
    (([1.0, Inf, 3.0], VE), Matrix{Real}, [1 Inf 3; 4 5 6]),
    (
        ((1, nothing, missing), (2, NaN, Inf)),
        Matrix{Union{Nothing, Missing, Real}},
        [1 nothing missing; 2 NaN Inf],
    ),
    (
        ([1, nothing, missing], [2, NaN, Inf]),
        Matrix{Union{Nothing, Missing, Real}},
        [1 nothing missing; 2 NaN Inf],
    ),
    (((1, nothing, missing), ("", NaN, Inf)), nothing, [1 nothing missing; "" NaN Inf]),
    (([1, nothing, missing], ["", NaN, Inf]), nothing, [1 nothing missing; "" NaN Inf]),
    ((('1', '2', '3'), ('4', '5', '6')), nothing, ['1' '2' '3'; '4' '5' '6']),
    ((['1', '2', '3'], ['4', '5', '6']), nothing, ['1' '2' '3'; '4' '5' '6']),
    ((("Aa", "Bb", "Cc"), ("Dd", "Ee", "Ff")), Matrix{String}, ["Aa" "Bb" "Cc"; "Dd" "Ee" "Ff"]),
    ((["Aa", "Bb", "Cc"], ["Dd", "Ee", "Ff"]), Matrix{String}, ["Aa" "Bb" "Cc"; "Dd" "Ee" "Ff"]),
    ((('1', '2', '3'), ("Dd", "Ee", "Ff")), Matrix{Any}, ['1' '2' '3'; "Dd" "Ee" "Ff"]),
    ((['1', '2', '3'], ["Dd", "Ee", "Ff"]), Matrix{Any}, ['1' '2' '3'; "Dd" "Ee" "Ff"]),
)

    @warn ""
    for an2___ in (an___, collect(an___))

        for an3___ in (an2___, collect.(an2___))
            @info "" an3___ typeof(an3___)

            if isnothing(ty)

                ret = typeof(re)

            else

                ret = ty

            end

            ma = BioLab.Matrix.make(an3___)

            @test typeof(ma) === ret

            @test isequal(ma, re)

            #@btime BioLab.Matrix.make($an3___)

        end

    end

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

        # 751.078 ns (19 allocations: 1.28 KiB)
        # 659.063 ns (15 allocations: 1.08 KiB)
        @btime BioLab.Matrix.collapse(mean, Float64, $ro_, MA)

    end

end

# ---- #

for n in (100, 1000, 10000, 20000)

    seed!(20230920)

    # 33.166 μs (375 allocations: 127.28 KiB)
    # 3.042 ms (1797 allocations: 11.92 MiB)
    # 572.708 ms (2770 allocations: 815.50 MiB)
    # 2.396 s (3103 allocations: 3.08 GiB)
    @btime BioLab.Matrix.collapse(
        mean,
        Float64,
        $([join(rand('A':'G', 3)) for _ in 1:n]),
        $(rand(n, n)),
    )

end
