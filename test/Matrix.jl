using Random: seed!

using StatsBase: mean

using Test: @test

using BioLab

# ---- #

@test BioLab.Error.@is isequal(BioLab.Matrix.make(((1, 2), (3, 4, 5))))

# ---- #

for (an___, re) in (
    (((1, 2, 3), (4, 5, 6)), [1 2 3; 4 5 6]),
    (((1, 2.0, 3), (4, 5, 6)), [1 2.0 3; 4 5 6]),
    (((1, NaN, 3), (4, 5, 6)), [1 NaN 3; 4 5 6]),
    (((1, nothing, 3), (4, 5, 6)), [1 nothing 3; 4 5 6]),
    (((1, missing, 3), (4, 5, 6)), [1 missing 3; 4 5 6]),
    (((1, nothing, 3), (missing, 4, 5), (7, 8, NaN)), [1 nothing 3; missing 4 5; 7 8 NaN]),
    ((('1', '2', '3'), ('4', '5', '6')), ['1' '2' '3'; '4' '5' '6']),
    (
        (
            (missing, 1, 2, 3),
            (nothing, 2, 3, 4),
            (Inf, 3, 4, 5),
            (-Inf, 4, 5, 6),
            (missing, nothing, Inf, -Inf),
            ('a', 'b', 'c', 'd'),
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

    for an___ in (an___, collect.(an___))

        for an___ in (an___, collect(an___))

            @test isequal(BioLab.Matrix.make(an___), re)

            # 123.897 ns (7 allocations: 656 bytes)
            # 142.668 ns (8 allocations: 736 bytes)
            # 123.385 ns (7 allocations: 656 bytes)
            # 142.274 ns (8 allocations: 736 bytes)
            # 288.072 ns (20 allocations: 1.23 KiB)
            # 653.117 ns (20 allocations: 1.19 KiB)
            # 586.578 ns (18 allocations: 1.12 KiB)
            # 499.352 ns (15 allocations: 1.02 KiB)
            # 288.143 ns (20 allocations: 1.23 KiB)
            # 654.764 ns (20 allocations: 1.19 KiB)
            # 586.592 ns (18 allocations: 1.12 KiB)
            # 501.725 ns (15 allocations: 1.02 KiB)
            # 265.096 ns (18 allocations: 1.14 KiB)
            # 372.573 ns (14 allocations: 1.02 KiB)
            # 163.660 ns (8 allocations: 768 bytes)
            # 441.500 ns (14 allocations: 1.02 KiB)
            # 267.971 ns (18 allocations: 1.14 KiB)
            # 373.780 ns (14 allocations: 1.02 KiB)
            # 163.320 ns (8 allocations: 768 bytes)
            # 471.939 ns (14 allocations: 1.02 KiB)
            # 609.494 ns (34 allocations: 2.22 KiB)
            # 605.824 ns (22 allocations: 1.52 KiB)
            # 581.718 ns (20 allocations: 1.48 KiB)
            # 731.953 ns (21 allocations: 1.50 KiB)
            # 123.757 ns (7 allocations: 624 bytes)
            # 143.761 ns (8 allocations: 704 bytes)
            # 123.484 ns (7 allocations: 624 bytes)
            # 143.404 ns (8 allocations: 704 bytes)
            # 3.016 μs (68 allocations: 6.34 KiB)
            # 743.644 ns (26 allocations: 1.70 KiB)
            # 1.408 μs (23 allocations: 1.75 KiB)
            # 1.312 μs (24 allocations: 1.67 KiB)
            #@btime BioLab.Matrix.make($an___)

        end

    end

end

# ---- #

const MA = [
    1 2
    10 20
    100 200
]

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
    (["Row 1", "Row 1", "Row 1"], ["Row 1"], [37.0 74.0]),
)

    if isnothing(ro2_)

        # There are not any rows to collapse.
        @test isnothing(BioLab.Matrix.collapse(mean, Float64, ro_, MA))

    else

        @test BioLab.Matrix.collapse(mean, Float64, ro_, MA) == (ro2_, ma2)

        # TODO: Comment out @info.
        # 753.915 ns (19 allocations: 1.31 KiB)
        # 646.598 ns (15 allocations: 1.08 KiB)
        #@btime BioLab.Matrix.collapse(mean, Float64, $ro_, $MA)

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
    #@btime BioLab.Matrix.collapse(mean, Float64, $ro_, $ma)

end
