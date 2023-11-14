using Test: @test

using Nucleus

# ---- #

using Random: seed!

using StatsBase: mean

# ---- #

const MA = [
    1 2
    10 20
    100 200
]

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

        # 700.395 ns (19 allocations: 1.28 KiB)
        # 602.744 ns (15 allocations: 1.08 KiB)
        #disable_logging(Info)
        #@btime Nucleus.Matrix.collapse(mean, Float64, $ro_, MA)
        #disable_logging(Debug)

    end

end

# ---- #

const CH_ = ('A', 'B', 'C', 'D', 'E', 'F', 'G')

# ---- #

for n in (100, 1000, 10000, 20000)

    seed!(20230920)

    # 28.791 μs (375 allocations: 127.28 KiB)
    # 2.975 ms (1797 allocations: 11.92 MiB)
    # 569.579 ms (2770 allocations: 815.50 MiB)
    # 2.397 s (3103 allocations: 3.08 GiB)
    #disable_logging(Info)
    #@btime Nucleus.Matrix.collapse(
    #    mean,
    #    Float64,
    #    $([Nucleus.String.make(CH_, 3) for _ in 1:n]),
    #    $(rand(n, n)),
    #)
    #disable_logging(Debug)

end
