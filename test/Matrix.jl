using Test: @test

using Logging: Debug, Info, disable_logging

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

    # 93.630 ns (9 allocations: 416 bytes)
    # 24.824 ns (1 allocation: 96 bytes)
    #
    # 22.716 ns (1 allocation: 96 bytes)
    # 23.738 ns (1 allocation: 96 bytes)
    #
    #
    # 24.222 ns (1 allocation: 112 bytes)
    # 25.518 ns (1 allocation: 112 bytes)
    #
    # 23.845 ns (1 allocation: 112 bytes)
    # 25.058 ns (1 allocation: 112 bytes)
    #
    #
    # 178.929 ns (14 allocations: 720 bytes)
    # 575.000 ns (13 allocations: 592 bytes)
    #
    # 532.852 ns (12 allocations: 608 bytes)
    # 400.205 ns (8 allocations: 416 bytes)
    #
    #
    # 180.337 ns (14 allocations: 720 bytes)
    # 572.115 ns (13 allocations: 592 bytes)
    #
    # 531.524 ns (12 allocations: 608 bytes)
    # 400.210 ns (8 allocations: 416 bytes)
    #
    #
    # 160.417 ns (12 allocations: 624 bytes)
    # 280.777 ns (7 allocations: 416 bytes)
    #
    # 64.692 ns (2 allocations: 224 bytes)
    # 372.956 ns (7 allocations: 416 bytes)
    #
    #
    # 163.644 ns (12 allocations: 624 bytes)
    # 281.284 ns (7 allocations: 416 bytes)
    #
    # 63.138 ns (2 allocations: 224 bytes)
    # 386.757 ns (7 allocations: 416 bytes)
    #
    #
    # 502.373 ns (28 allocations: 1.69 KiB)
    # 514.911 ns (15 allocations: 928 bytes)
    #
    # 463.434 ns (14 allocations: 976 bytes)
    # 664.581 ns (14 allocations: 912 bytes)
    #
    #
    # 23.302 ns (1 allocation: 80 bytes)
    # 25.309 ns (1 allocation: 80 bytes)
    #
    # 23.720 ns (1 allocation: 80 bytes)
    # 25.017 ns (1 allocation: 80 bytes)
    #
    #
    # 2.889 μs (62 allocations: 5.81 KiB)
    # 600.282 ns (19 allocations: 1.06 KiB)
    #
    # 1.858 μs (17 allocations: 1.22 KiB)
    # 1.371 μs (17 allocations: 1.03 KiB)

    for an___ in (an___, collect.(an___))

        for an___ in (an___, collect(an___))

            @test isequal(BioLab.Matrix.make(an___), re)

            @btime BioLab.Matrix.make($an___)

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

        disable_logging(Info)

        # 734.756 ns (20 allocations: 1.31 KiB)
        # 641.104 ns (16 allocations: 1.11 KiB)
        @btime BioLab.Matrix.collapse(mean, Float64, $ro_, $MA)

        disable_logging(Debug)

    end

end
