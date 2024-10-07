using Significance

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Random: seed!

# ---- #

for (un, re) in (
    (10, 5.666282602806655),
    (100, 2.0883721941943625),
    (1000, 0.6188797076691194),
    (10000, 0.1962619872305363),
)

    seed!(20249004)

    sa_ = randn(un) * 10

    @test isapprox(Significance.get_margin_of_error(sa_), re)

    # 22.131 ns (0 allocations: 0 bytes)
    # 30.684 ns (0 allocations: 0 bytes)
    # 60.633 ns (0 allocations: 0 bytes)
    # 547.207 ns (0 allocations: 0 bytes)
    # 4.000 μs (0 allocations: 0 bytes)
    #@btime Significance.get_margin_of_error($sa_)

end

# ---- #

seed!(20230612)

const SA_ = randn(1000)

for (co, re) in (
    (0, 0.0),
    (0.001, 4.0685463561927655e-5),
    (0.5, 0.021895485060908798),
    (0.95, 0.06362492851958153),
    (1, Inf),
)

    @test isapprox(Significance.get_margin_of_error(SA_, co), re)

    # 535.270 ns (0 allocations: 0 bytes)
    # 534.392 ns (0 allocations: 0 bytes)
    # 534.426 ns (0 allocations: 0 bytes)
    # 546.543 ns (0 allocations: 0 bytes)
    # 530.700 ns (0 allocations: 0 bytes)
    #@btime Significance.get_margin_of_error(SA_, $co)

end

# ---- #

@test Significance.get_p_value(NaN, 0) === 1.0

for (us, re) in ((0, 0.1), (1, 0.1), (2, 0.2))

    @test Significance.get_p_value(us, 10) === re

    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.458 ns (0 allocations: 0 bytes)
    #@btime Significance.get_p_value($us, 10)

end

# ---- #

const NU_ = [-1, -0.0, 0, 1]

const RA_ = [-4, -3, -2, -1, -0.0, 0, 1, 2, 3, 4]

# ---- #

for (fu, re) in (
    (<=, ([0.4, 0.6, 0.6, 0.7], [0.7, 0.7, 0.7, 0.7])),
    (>=, ([0.7, 0.6, 0.6, 0.4], [0.7, 0.7, 0.7, 0.7])),
)

    @test Significance.get_p_value(fu, NU_, RA_) == re

    # 192.633 ns (6 allocations: 512 bytes)
    # 199.167 ns (6 allocations: 512 bytes)
    #@btime Significance.get_p_value($fu, NU_, RA_)

end

# ---- #

const IE_ = findall(<(0), NU_)

const IP_ = findall(>=(0), NU_)

@test Significance.get_p_value(NU_, IE_, IP_, RA_) ==
      ([1.0], [1.0], [1.0, 1.0, 2 / 3], [1.0, 1.0, 1.0])

# 391.373 ns (15 allocations: 1.03 KiB)
#@btime Significance.get_p_value(NU_, IE_, IP_, RA_);
