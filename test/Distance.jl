using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

for fa in (0.1, 1, 10)

    n1 = 1 * fa

    n2 = 2 * fa

    @test Nucleus.Distance.EU(n1, n2) === 1.0 * fa

    # 1.459 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.458 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Distance.EU($n1, $n2)

end

# ---- #

for nn in 1:8

    n1_ = fill(1, nn)

    n2_ = fill(2, nn)

    @test Nucleus.Distance.EU(n1_, n2_) / sqrt(nn) === 1.0

    # 3.000 ns (0 allocations: 0 bytes)
    # 3.000 ns (0 allocations: 0 bytes)
    # 4.583 ns (0 allocations: 0 bytes)
    # 3.666 ns (0 allocations: 0 bytes)
    # 4.083 ns (0 allocations: 0 bytes)
    # 4.416 ns (0 allocations: 0 bytes)
    # 4.875 ns (0 allocations: 0 bytes)
    # 4.708 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Distance.EU($n1_, $n2_)

end

# ---- #

for (n1_, n2_, re) in (
    # allequal
    ([1], [2], NaN),
    ([1, 1], [2, 2], NaN),
    ([1, 1], [1, 2], NaN),
    ([1, 2], [1, 1], NaN),
    # ==
    ([1, 2], [1, 2], 0.1339745962155614),
    ([1, 2], [1.0, 2], 0.0),
    ([1, 2], [1, 2 + eps()], 0.0),
    # Integer
    ([1, 2], [1, 3], 0.1339745962155614),
    ([1, 2], [1, 4], 0.1339745962155614),
    # Integer vs AbstractFloat
    ([1, 2, 3], [1, 2, 4], 0.057190958417936644),
    ([1.0, 2, 3], [1, 2, 4], 0.06160436857756835),
    # ~
    ([1, 2], [1, 2.001], 0.0),
    ([1, 2, 3], [1, 2, 3.001], 0.0571909584182676),
    ([1, 2, 3, 4], [1, 2, 3, 4.001], 0.03175416344821147),
)

    @test Nucleus.Distance.IN(n1_, n2_) === re

    # 642.188 ns (34 allocations: 2.48 KiB)
    # 663.522 ns (34 allocations: 2.48 KiB)
    # 724.000 ns (34 allocations: 2.52 KiB)
    # 705.616 ns (34 allocations: 2.52 KiB)
    # 713.585 ns (34 allocations: 2.55 KiB)
    # 22.632 ns (1 allocation: 16 bytes)
    # 22.632 ns (1 allocation: 16 bytes)
    # 717.153 ns (34 allocations: 2.55 KiB)
    # 715.684 ns (34 allocations: 2.55 KiB)
    # 815.895 ns (34 allocations: 2.61 KiB)
    # 25.167 μs (46 allocations: 52.56 KiB)
    # 22.609 ns (1 allocation: 16 bytes)
    # 24.542 μs (46 allocations: 52.56 KiB)
    # 24.792 μs (46 allocations: 52.59 KiB)
    #@btime Nucleus.Distance.IN($n1_, $n2_)

end

# ---- #

const FU_ = Nucleus.Distance.EU, Nucleus.Distance.CO, Nucleus.Distance.IN

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
        (
            0.1339745962155614,
            1.8660254037844386,
            0.057190958417936644,
            1.9428090415820634,
            0.031754163448145745,
            1.9682458365518543,
        ),
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

        # 3.125 ns (0 allocations: 0 bytes)
        # 3.208 ns (0 allocations: 0 bytes)
        # 4.583 ns (0 allocations: 0 bytes)
        # 4.583 ns (0 allocations: 0 bytes)
        # 3.625 ns (0 allocations: 0 bytes)
        # 3.625 ns (0 allocations: 0 bytes)
        # 49.477 ns (2 allocations: 160 bytes)
        # 50.659 ns (2 allocations: 160 bytes)
        # 50.954 ns (2 allocations: 160 bytes)
        # 51.039 ns (2 allocations: 160 bytes)
        # 48.119 ns (2 allocations: 192 bytes)
        # 48.035 ns (2 allocations: 192 bytes)
        # 714.765 ns (34 allocations: 2.55 KiB)
        # 751.078 ns (34 allocations: 2.55 KiB)
        # 766.204 ns (34 allocations: 2.61 KiB)
        # 769.860 ns (34 allocations: 2.61 KiB)
        # 813.759 ns (34 allocations: 2.73 KiB)
        # 843.750 ns (34 allocations: 2.73 KiB)
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
                0       0.057191  0.057191  0.057191
                0.057191  0       0.057191  0.057191
                0.057191  0.057191  0       0.057191
                0.057191  0.057191  0.057191  0
            ],
            [
                0        0.133975   0.0616044  0.0616044
                0.133975   0        0.0616044  0.0616044
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

        @test isapprox(Nucleus.Distance.pairwise(fu, nu___), re; atol = 1e-5)

        # 47.017 ns (1 allocation: 192 bytes)
        # 46.975 ns (1 allocation: 192 bytes)
        # 357.143 ns (13 allocations: 1.12 KiB)
        # 315.346 ns (13 allocations: 1.12 KiB)
        # 6.025 μs (215 allocations: 16.00 KiB)
        # 153.000 μs (287 allocations: 315.72 KiB)
        #@btime Nucleus.Distance.pairwise($fu, $nu___)

    end

end

# ---- #

for nn in (10, 100, 1000)

    seed!(20240201)

    nu___ = rand(nn), rand(nn)

    for fu in FU_

        # 28.308 ns (1 allocation: 96 bytes)
        # 77.651 ns (3 allocations: 384 bytes)
        # 27.125 μs (50 allocations: 52.83 KiB)
        # 41.498 ns (1 allocation: 96 bytes)
        # 150.170 ns (3 allocations: 1.84 KiB)
        # 31.709 μs (50 allocations: 54.30 KiB)
        # 317.050 ns (1 allocation: 96 bytes)
        # 1.100 μs (3 allocations: 15.97 KiB)
        # 80.458 μs (51 allocations: 68.44 KiB)
        #@btime Nucleus.Distance.pairwise($fu, $nu___)

    end

end
