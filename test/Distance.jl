using Test: @test

using Nucleus

# ---- #

using Distances: CorrDist, Euclidean, pairwise

using Random: seed!

# ---- #

for fa in (0.1, 1, 10)

    n1 = 1 * fa

    n2 = 2 * fa

    @test Euclidean()(n1, n2) === 1.0 * fa

    # 1.458 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.458 ns (0 allocations: 0 bytes)
    #@btime Euclidean()($n1, $n2)

end

# ---- #

for nn in 1:8

    n1_ = fill(1, nn)

    n2_ = fill(2, nn)

    @test Euclidean()(n1_, n2_) / sqrt(nn) === 1.0

    # 3.042 ns (0 allocations: 0 bytes)
    # 3.083 ns (0 allocations: 0 bytes)
    # 3.333 ns (0 allocations: 0 bytes)
    # 3.333 ns (0 allocations: 0 bytes)
    # 3.666 ns (0 allocations: 0 bytes)
    # 3.625 ns (0 allocations: 0 bytes)
    # 4.250 ns (0 allocations: 0 bytes)
    # 4.250 ns (0 allocations: 0 bytes)
    #@btime Euclidean()($n1_, $n2_)

end

# ---- #

const FU_ = Euclidean(), CorrDist(), Nucleus.Distance.InformationDistance()

# ---- #

for (fu, re_) in zip(
    FU_,
    (
        (0.0, 1.4142135623730951, 0.0, 2.8284271247461903, 0.0, 4.47213595499958),
        (
            2.220446049250313e-16,
            1.9999999999999998,
            2.220446049250313e-16,
            1.9999999999999998,
            2.220446049250313e-16,
            1.9999999999999998,
        ),
        (0.0, 2.0, 0.0, 2.0, 0.0, 2.0),
    ),
)

    for ((n1_, n2_), re) in zip(
        (
            ([1, 2], [1, 2]),
            ([1, 2], [2, 1]),
            ([1, 2, 3], [1, 2, 3]),
            ([1, 2, 3], [3, 2, 1]),
            ([1, 2, 3, 4], [1, 2, 3, 4]),
            ([1, 2, 3, 4], [4, 3, 2, 1]),
        ),
        re_,
    )

        @test fu(n1_, n2_) === re

        # 3.083 ns (0 allocations: 0 bytes)
        # 3.083 ns (0 allocations: 0 bytes)
        # 3.166 ns (0 allocations: 0 bytes)
        # 3.167 ns (0 allocations: 0 bytes)
        # 3.208 ns (0 allocations: 0 bytes)
        # 3.166 ns (0 allocations: 0 bytes)
        # 43.645 ns (2 allocations: 160 bytes)
        # 43.684 ns (2 allocations: 160 bytes)
        # 44.992 ns (2 allocations: 160 bytes)
        # 44.907 ns (2 allocations: 160 bytes)
        # 44.361 ns (2 allocations: 192 bytes)
        # 44.441 ns (2 allocations: 192 bytes)
        # 33.743 ns (2 allocations: 32 bytes)
        # 33.702 ns (2 allocations: 32 bytes)
        # 33.736 ns (2 allocations: 32 bytes)
        # 33.710 ns (2 allocations: 32 bytes)
        # 34.954 ns (2 allocations: 32 bytes)
        # 34.575 ns (2 allocations: 32 bytes)
        #@btime $fu($n1_, $n2_)

    end

end

# ---- #

for (fu, re_) in zip(
    FU_,
    (
        (
            [
                0      1.41421  1      1
                1.41421  0      1      1
                1      1      0      1.41421
                1      1      1.41421  0
            ],
            [
                0      1.41421  1      1
                1.41421  0      1      1
                1      1      0      1.41421
                1      1      1.41421  0
            ],
        ),
        (
            [
                0          2.22045e-16  0.0180195  0.0180195
                2.22045e-16  0          0.0180195  0.0180195
                0.0180195    0.0180195    0        0.0714286
                0.0180195    0.0180195    0.0714286  0
            ],
            [
                0          2.22045e-16  0.0180195  0.0180195
                2.22045e-16  0          0.0180195  0.0180195
                0.0180195    0.0180195    0        0.0714286
                0.0180195    0.0180195    0.0714286  0
            ],
        ),
        (
            [
                0       0       0.057191  0.057191
                0       0       0.057191  0.057191
                0.057191  0.057191  0       0.057191
                0.057191  0.057191  0.057191  0
            ],
            [
                0        0        0.0616044  0.0616044
                0        0        0.0616044  0.0616044
                0.0616044  0.0616044  0        0.059374
                0.0616044  0.0616044  0.059374   0
            ],
        ),
    ),
)

    for (nu___, re) in zip(
        (
            ([-1, 0, 1], [-2, 0, 2], [-1, 0, 2], [-2, 0, 1]),
            ([-1.0, 0, 1], [-2.0, 0, 2], [-1.0, 0, 2], [-2.0, 0, 1]),
        ),
        re_,
    )

        @test isapprox(pairwise(fu, nu___), re; atol = 1e-5)

        # 47.270 ns (1 allocation: 192 bytes)
        # 46.806 ns (1 allocation: 192 bytes)
        # 298.533 ns (13 allocations: 1.12 KiB)
        # 297.414 ns (13 allocations: 1.12 KiB)
        # 3.982 μs (183 allocations: 13.42 KiB)
        # 124.708 μs (243 allocations: 266.94 KiB)
        #@btime pairwise($fu, $nu___)

    end

end

# ---- #

for nn in (10, 100, 1000)

    seed!(20240201)

    nu___ = rand(nn), rand(nn), rand(nn)

    for fu in FU_

        # 37.424 ns (1 allocation: 128 bytes)
        # 180.459 ns (7 allocations: 992 bytes)
        # 79.916 μs (145 allocations: 160.53 KiB)
        # 78.556 ns (1 allocation: 128 bytes)
        # 406.036 ns (7 allocations: 5.38 KiB)
        # 94.041 μs (145 allocations: 164.94 KiB)
        # 879.808 ns (1 allocation: 128 bytes)
        # 3.234 μs (7 allocations: 48.12 KiB)
        # 241.209 μs (148 allocations: 207.73 KiB)
        #@btime pairwise($fu, $nu___)

    end

end

# ---- #

for (a1, a2, re) in (
    #
    (1.23, 1.23, 0),
    #
    (0, 0, 0),
    (0, 1, 1),
    (0, 2, 2),
    (0, 3, 1),
    (0, 4, 2),
    #
    (1, 0, -1),
    (1, 1, 0),
    (1, 2, 1),
    (1, 3, 0),
    (1, 4, 1),
    # 2 != 0.
    (2, 0, -2),
    (2, 1, -1),
    (2, 2, 0),
    (2, 3, -1),
    (2, 4, 0),
    #
    (0, -1, 1),
    (0, -2, 0),
    (0, -3, 1),
    (0, -4, 0),
    #
    (-1, 0, -1),
    (-1, -1, 0),
    (-1, -2, -1),
    (-1, -3, 0),
    (-1, -4, -1),
    # -2 == 0.
    (-2, 0, 0),
    (-2, -1, 1),
    (-2, -2, 0),
    (-2, -3, 1),
    (-2, -4, 0),
)

    a1 *= pi

    a2 *= pi

    re *= pi

    @test isapprox(Nucleus.Distance.AngularDistance()(a1, a2), re; atol = 1e-2)

    @test isapprox(Nucleus.Distance.AngularDistance()(a2, a1), -re; atol = 1e-2)

    if re < 0

        re = -re

    end

    @test isapprox(Nucleus.Distance.AngularDistanceNorm()(a1, a2), re)

    @test isapprox(Nucleus.Distance.AngularDistanceNorm()(a2, a1), re)

    # 3.958 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.959 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 8.333 ns (0 allocations: 0 bytes)
    # 8.467 ns (0 allocations: 0 bytes)
    # 8.133 ns (0 allocations: 0 bytes)
    # 8.299 ns (0 allocations: 0 bytes)
    # 8.292 ns (0 allocations: 0 bytes)
    # 8.383 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.959 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 8.299 ns (0 allocations: 0 bytes)
    # 8.466 ns (0 allocations: 0 bytes)
    # 8.125 ns (0 allocations: 0 bytes)
    # 8.258 ns (0 allocations: 0 bytes)
    # 8.292 ns (0 allocations: 0 bytes)
    # 8.341 ns (0 allocations: 0 bytes)
    # 8.291 ns (0 allocations: 0 bytes)
    # 8.466 ns (0 allocations: 0 bytes)
    # 8.300 ns (0 allocations: 0 bytes)
    # 8.466 ns (0 allocations: 0 bytes)
    # 13.222 ns (0 allocations: 0 bytes)
    # 13.346 ns (0 allocations: 0 bytes)
    # 12.929 ns (0 allocations: 0 bytes)
    # 13.096 ns (0 allocations: 0 bytes)
    # 12.930 ns (0 allocations: 0 bytes)
    # 13.138 ns (0 allocations: 0 bytes)
    # 5.500 ns (0 allocations: 0 bytes)
    # 5.500 ns (0 allocations: 0 bytes)
    # 7.375 ns (0 allocations: 0 bytes)
    # 7.375 ns (0 allocations: 0 bytes)
    # 8.592 ns (0 allocations: 0 bytes)
    # 8.634 ns (0 allocations: 0 bytes)
    # 7.375 ns (0 allocations: 0 bytes)
    # 7.382 ns (0 allocations: 0 bytes)
    # 5.541 ns (0 allocations: 0 bytes)
    # 5.541 ns (0 allocations: 0 bytes)
    # 5.791 ns (0 allocations: 0 bytes)
    # 5.791 ns (0 allocations: 0 bytes)
    # 8.300 ns (0 allocations: 0 bytes)
    # 8.466 ns (0 allocations: 0 bytes)
    # 9.541 ns (0 allocations: 0 bytes)
    # 9.718 ns (0 allocations: 0 bytes)
    # 8.299 ns (0 allocations: 0 bytes)
    # 8.341 ns (0 allocations: 0 bytes)
    # 7.382 ns (0 allocations: 0 bytes)
    # 7.382 ns (0 allocations: 0 bytes)
    # 8.466 ns (0 allocations: 0 bytes)
    # 8.466 ns (0 allocations: 0 bytes)
    # 11.052 ns (0 allocations: 0 bytes)
    # 11.052 ns (0 allocations: 0 bytes)
    # 12.345 ns (0 allocations: 0 bytes)
    # 12.303 ns (0 allocations: 0 bytes)
    # 10.802 ns (0 allocations: 0 bytes)
    # 10.802 ns (0 allocations: 0 bytes)

    #@btime Nucleus.Distance.AngularDistance()($a1, $a2)

    #@btime Nucleus.Distance.AngularDistanceNorm()($a1, $a2)

end
