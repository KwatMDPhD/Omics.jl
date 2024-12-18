using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Random: seed!

# ---- #

# 31.019 ns (0 allocations: 0 bytes)
# 54.865 ns (0 allocations: 0 bytes)
# 297.233 ns (0 allocations: 0 bytes)
# 2.343 μs (0 allocations: 0 bytes)
for (un, re) in (
    (10, 6.597957136428492),
    (100, 1.8754776361269154),
    (1000, 0.61731275423233716188797076691194),
    (10000, 0.1964827926939546),
)

    seed!(20240904)

    sa_ = randn(un) * 10

    @test isapprox(Omics.Significance.get_margin_of_error(sa_), re)

    #@btime Omics.Significance.get_margin_of_error($sa_)

end

# ---- #

seed!(20230612)

const SA_ = randn(1000)

# 294.610 ns (0 allocations: 0 bytes)
# 293.680 ns (0 allocations: 0 bytes)
# 293.680 ns (0 allocations: 0 bytes)
# 297.253 ns (0 allocations: 0 bytes)
# 294.610 ns (0 allocations: 0 bytes)
for (co, re) in (
    (0, 0.0),
    (0.001, 4.0685463561927655e-5),
    (0.5, 0.021895485060908798),
    (0.95, 0.06362492851958153),
    (1, Inf),
)

    @test isapprox(Omics.Significance.get_margin_of_error(SA_, co), re)

    #@btime Omics.Significance.get_margin_of_error(SA_, $co)

end

# ---- #

@test Omics.Significance.get_p_value(0, NaN) === 1.0

# 2.083 ns (0 allocations: 0 bytes)
# 2.083 ns (0 allocations: 0 bytes)
# 2.084 ns (0 allocations: 0 bytes)
for (us, re) in ((0, 0.1), (1, 0.1), (2, 0.2))

    @test Omics.Significance.get_p_value(10, us) === re

    #@btime Omics.Significance.get_p_value(10, $us)

end

# ---- #

const RA_ = [-4, -3, -2, -1, -0.0, 0, 1, 2, 3, 4]

const NU_ = [-1, -0.0, 0, 1]

# ---- #

# 148.441 ns (11 allocations: 512 bytes)
# 157.663 ns (11 allocations: 512 bytes)
for (fu, re) in (
    (<=, ([0.4, 0.6, 0.6, 0.7], [0.7, 0.7, 0.7, 0.7])),
    (>=, ([0.7, 0.6, 0.6, 0.4], [0.7, 0.7, 0.7, 0.7])),
)

    @test Omics.Significance.get_p_value(fu, RA_, NU_) == re

    #@btime Omics.Significance.get_p_value($fu, RA_, NU_)

end

# ---- #

const IE_ = findall(<(0), NU_)

const IP_ = findall(>=(0), NU_)

@test Omics.Significance.get_p_value(RA_, NU_, IE_, IP_) ==
      ([1.0], [1.0], [1, 1, 2 / 3], [1.0, 1, 1])

# 290.275 ns (24 allocations: 1.00 KiB)
#@btime Omics.Significance.get_p_value(RA_, NU_, IE_, IP_);
