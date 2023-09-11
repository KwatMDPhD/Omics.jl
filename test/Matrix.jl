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

            # 123.033 ns (7 allocations: 656 bytes)
            # 141.834 ns (8 allocations: 736 bytes)
            # 123.750 ns (7 allocations: 656 bytes)
            # 141.374 ns (8 allocations: 736 bytes)
            # 312.675 ns (22 allocations: 1.33 KiB)
            # 661.096 ns (20 allocations: 1.22 KiB)
            # 609.104 ns (18 allocations: 1.12 KiB)
            # 485.897 ns (15 allocations: 1.05 KiB)
            # 313.717 ns (22 allocations: 1.33 KiB)
            # 667.722 ns (20 allocations: 1.22 KiB)
            # 614.642 ns (18 allocations: 1.12 KiB)
            # 485.467 ns (15 allocations: 1.05 KiB)
            # 288.900 ns (20 allocations: 1.22 KiB)
            # 371.558 ns (14 allocations: 1.05 KiB)
            # 164.573 ns (8 allocations: 768 bytes)
            # 448.232 ns (14 allocations: 1.05 KiB)
            # 293.242 ns (20 allocations: 1.22 KiB)
            # 369.942 ns (14 allocations: 1.05 KiB)
            # 164.399 ns (8 allocations: 768 bytes)
            # 455.584 ns (14 allocations: 1.05 KiB)
            # 753.261 ns (39 allocations: 2.53 KiB)
            # 604.881 ns (22 allocations: 1.58 KiB)
            # 550.532 ns (20 allocations: 1.55 KiB)
            # 703.965 ns (21 allocations: 1.56 KiB)
            # 124.632 ns (7 allocations: 624 bytes)
            # 143.747 ns (8 allocations: 704 bytes)
            # 124.816 ns (7 allocations: 624 bytes)
            # 142.836 ns (8 allocations: 704 bytes)
            # 3.250 μs (73 allocations: 6.78 KiB)
            # 739.754 ns (26 allocations: 1.77 KiB)
            # 1.458 μs (23 allocations: 1.75 KiB)
            # 1.525 μs (24 allocations: 1.73 KiB)
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

        @test isnothing(BioLab.Matrix.collapse(mean, Float64, ro_, MA))

    else

        @test BioLab.Matrix.collapse(mean, Float64, ro_, MA) == (ro2_, ma2)

        # 719.617 ns (19 allocations: 1.28 KiB)
        # 618.175 ns (15 allocations: 1.08 KiB)
        # TODO: Comment out @info.
        #@btime BioLab.Matrix.collapse(mean, Float64, $ro_, $MA)

    end

end
