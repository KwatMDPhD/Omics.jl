using Random: seed!

using Test: @test

using Omics

# ---- #

# 31.019 ns (0 allocations: 0 bytes)
# 54.865 ns (0 allocations: 0 bytes)
# 297.233 ns (0 allocations: 0 bytes)
# 2.343 μs (0 allocations: 0 bytes)
for (ur, re) in (
    (10, 6.597957136428492),
    (100, 1.8754776361269154),
    (1000, 0.61731275423233716188797076691194),
    (10000, 0.1964827926939546),
)

    seed!(20240904)

    sa_ = randn(ur) * 10

    @test isapprox(Omics.Significance.get_margin_of_error(sa_), re)

    #@btime Omics.Significance.get_margin_of_error($sa_)

end

# ---- #

seed!(20230612)

const SA_ = randn(1000)

# 293.680 ns (0 allocations: 0 bytes)
# 293.693 ns (0 allocations: 0 bytes)
# 293.545 ns (0 allocations: 0 bytes)
# 297.233 ns (0 allocations: 0 bytes)
# 293.850 ns (0 allocations: 0 bytes)
for (co, re) in (
    (0.0, 0.0),
    (0.001, 4.0685463561927655e-5),
    (0.5, 0.021895485060908798),
    (0.95, 0.06362492851958153),
    (1.0, Inf),
)

    @test isapprox(Omics.Significance.get_margin_of_error(SA_, co), re)

    #@btime Omics.Significance.get_margin_of_error(SA_, $co)

end

# ---- #

@test Omics.Significance.ge(0, NaN) === 1.0

# ---- #

# 2.083 ns (0 allocations: 0 bytes)
# 2.083 ns (0 allocations: 0 bytes)
# 2.084 ns (0 allocations: 0 bytes)
for (us, re) in ((0, 0.1), (1, 0.1), (2, 0.2))

    @test Omics.Significance.ge(10, us) === re

    #@btime Omics.Significance.ge(10, $us)

end

# ---- #

const RA_ = [-4, -3, -2, -1, -0.0, 0, 1, 2, 3, 4]

const NU_ = [-1, -0.0, 0, 1]

# ---- #

# 147.637 ns (11 allocations: 512 bytes)
# 155.833 ns (11 allocations: 512 bytes)
for (eq, re) in (
    (<=, ([0.4, 0.6, 0.6, 0.7], [0.7, 0.7, 0.7, 0.7])),
    (>=, ([0.7, 0.6, 0.6, 0.4], [0.7, 0.7, 0.7, 0.7])),
)

    @test Omics.Significance.ge(eq, RA_, NU_) == re

    #@btime Omics.Significance.ge($eq, RA_, NU_)

end

# ---- #

const IL_ = findall(<(0.0), NU_)

const IG_ = findall(>=(0.0), NU_)

@test Omics.Significance.ge(RA_, NU_, IL_, IG_) ==
      ([1.0], [1.0], [1, 1, 2 / 3], [1.0, 1, 1])

# 267.857 ns (24 allocations: 1.00 KiB)
#@btime Omics.Significance.ge(RA_, NU_, IL_, IG_);
