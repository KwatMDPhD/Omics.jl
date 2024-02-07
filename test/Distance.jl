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

        # 3.166 ns (0 allocations: 0 bytes)
        # 3.125 ns (0 allocations: 0 bytes)
        # 4.583 ns (0 allocations: 0 bytes)
        # 4.583 ns (0 allocations: 0 bytes)
        # 3.666 ns (0 allocations: 0 bytes)
        # 3.666 ns (0 allocations: 0 bytes)
        # 45.492 ns (2 allocations: 160 bytes)
        # 45.332 ns (2 allocations: 160 bytes)
        # 47.360 ns (2 allocations: 160 bytes)
        # 47.402 ns (2 allocations: 160 bytes)
        # 46.679 ns (2 allocations: 192 bytes)
        # 47.565 ns (2 allocations: 192 bytes)
        # 32.780 ns (2 allocations: 32 bytes)
        # 32.486 ns (2 allocations: 32 bytes)
        # 33.442 ns (2 allocations: 32 bytes)
        # 33.442 ns (2 allocations: 32 bytes)
        # 34.358 ns (2 allocations: 32 bytes)
        # 33.610 ns (2 allocations: 32 bytes)
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

        @test isapprox(Nucleus.Distance.pairwise(fu, nu___), re; atol = 1e-5)

        # 46.933 ns (1 allocation: 192 bytes)
        # 46.975 ns (1 allocation: 192 bytes)
        # 314.062 ns (13 allocations: 1.12 KiB)
        # 354.562 ns (13 allocations: 1.12 KiB)
        # 5.132 μs (183 allocations: 13.42 KiB)
        # 126.750 μs (243 allocations: 263.19 KiB)
        #@btime Nucleus.Distance.pairwise($fu, $nu___)

    end

end

# ---- #

for nn in (10, 100, 1000)

    seed!(20240201)

    nu___ = rand(nn), rand(nn), rand(nn)

    for fu in FU_

        # 37.177 ns (1 allocation: 128 bytes)
        # 191.111 ns (7 allocations: 992 bytes)
        # 81.125 μs (145 allocations: 158.28 KiB)
        # 77.615 ns (1 allocation: 128 bytes)
        # 413.144 ns (7 allocations: 5.38 KiB)
        # 94.750 μs (145 allocations: 162.69 KiB)
        # 881.283 ns (1 allocation: 128 bytes)
        # 3.229 μs (7 allocations: 47.75 KiB)
        # 247.584 μs (148 allocations: 205.11 KiB)
        #@btime Nucleus.Distance.pairwise($fu, $nu___)

    end

end
