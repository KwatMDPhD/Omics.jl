using Random: seed!

using Test: @test

using Omics

# ---- #

const FL___ = [0, 1, 2.0],
[-1, 0, 0.3333333333333333, 1],
[
    1 3 5
    2 4 6.0
]

# ---- #

for (nu_, re) in zip(FL___, (
    [0, 1, 2.0],
    [0, 1, 1.3333333333333333, 2],
    [
        0 2 4
        1 3 5.0
    ],
))

    co = copy(nu_)

    Omics.RangeNormalization.shift!(co)

    @test co == re

end

# ---- #

for (fl_, re) in zip(
    FL___,
    (
        [1, log2(3), 2],
        [1, log2(3), log2(3.3333333333333333), 2],
        [
            1 2 log2(6)
            log2(3) log2(5) log2(7)
        ],
    ),
)

    co = copy(fl_)

    Omics.RangeNormalization.shift_log2!(co, 2.0)

    @test isapprox(co, re)

end

# ---- #

for (fl_, re) in zip(
    FL___,
    (
        [-1, 0, 1.0],
        [-1.3, -0.09999999999999999, 0.30000000000000004, 1.1000000000000003],
        [
            -1.3363062095621219 -0.2672612419124244 0.8017837257372732
            -0.8017837257372732 0.2672612419124244 1.3363062095621219
        ],
    ),
)

    co = copy(fl_)

    Omics.RangeNormalization.do_0!(co)

    @test co == re

end

# ---- #

for (fl_, re) in zip(
    FL___,
    (
        [0, 0.5, 1],
        [0, 0.5, 0.6666666666666666, 1],
        [
            0 0.4 0.8
            0.2 0.6000000000000001 1
        ],
    ),
)

    co = copy(fl_)

    Omics.RangeNormalization.do_01!(co)

    @test co == re

end

# ---- #

for (fl_, re) in zip(
    FL___[[1, 3]],
    (
        [0, 0.3333333333333333, 0.6666666666666666],
        [
            0.047619047619047616 0.14285714285714285 0.23809523809523808
            0.09523809523809523 0.19047619047619047 0.2857142857142857
        ],
    ),
)

    co = copy(fl_)

    Omics.RangeNormalization.do_sum!(co)

    @test co == re

end

# ---- #

# 10.416 μs (0 allocations: 0 bytes)
# 57.917 μs (0 allocations: 0 bytes)
# 4.298 μs (0 allocations: 0 bytes)
# 50.083 μs (0 allocations: 0 bytes)
# 1.983 μs (0 allocations: 0 bytes)

for fu in (
    Omics.RangeNormalization.shift!,
    Omics.RangeNormalization.shift_log2!,
    Omics.RangeNormalization.do_0!,
    Omics.RangeNormalization.do_01!,
    Omics.RangeNormalization.do_sum!,
)

    seed!(20250216)

    #@btime $fu($(rand(10000)))

end
