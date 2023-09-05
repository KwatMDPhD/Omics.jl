using StatsBase: mean

using Test: @test

using BioLab

# ---- #

for (an___, re) in (
    (((1, 2), (3, 4, 5)), [1 2; 3 4]),
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

            # 93.674 ns (9 allocations: 416 bytes)
            # 24.933 ns (1 allocation: 96 bytes)
            # 22.902 ns (1 allocation: 96 bytes)
            # 24.013 ns (1 allocation: 96 bytes)
            # 23.636 ns (1 allocation: 112 bytes)
            # 25.518 ns (1 allocation: 112 bytes)
            # 23.929 ns (1 allocation: 112 bytes)
            # 25.226 ns (1 allocation: 112 bytes)
            # 178.453 ns (14 allocations: 720 bytes)
            # 522.031 ns (13 allocations: 592 bytes)
            # 477.138 ns (12 allocations: 608 bytes)
            # 371.141 ns (8 allocations: 416 bytes)
            # 179.976 ns (14 allocations: 720 bytes)
            # 523.340 ns (13 allocations: 592 bytes)
            # 477.990 ns (12 allocations: 608 bytes)
            # 368.698 ns (8 allocations: 416 bytes)
            # 160.692 ns (12 allocations: 624 bytes)
            # 253.521 ns (7 allocations: 416 bytes)
            # 63.138 ns (2 allocations: 224 bytes)
            # 339.097 ns (7 allocations: 416 bytes)
            # 163.591 ns (12 allocations: 624 bytes)
            # 254.107 ns (7 allocations: 416 bytes)
            # 63.010 ns (2 allocations: 224 bytes)
            # 347.350 ns (7 allocations: 416 bytes)
            # 492.912 ns (28 allocations: 1.69 KiB)
            # 476.403 ns (15 allocations: 928 bytes)
            # 416.251 ns (14 allocations: 976 bytes)
            # 600.614 ns (14 allocations: 912 bytes)
            # 23.301 ns (1 allocation: 80 bytes)
            # 25.267 ns (1 allocation: 80 bytes)
            # 23.678 ns (1 allocation: 80 bytes)
            # 24.891 ns (1 allocation: 80 bytes)
            # 2.870 μs (62 allocations: 5.81 KiB)
            # 597.612 ns (19 allocations: 1.06 KiB)
            # 1.754 μs (17 allocations: 1.22 KiB)
            # 1.312 μs (17 allocations: 1.03 KiB)
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

        # 734.460 ns (19 allocations: 1.28 KiB)
        # 644.697 ns (15 allocations: 1.08 KiB)
        # TODO: Comment out @info.
        #@btime BioLab.Matrix.collapse(mean, Float64, $ro_, $MA)

    end

end
