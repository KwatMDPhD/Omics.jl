using Random: seed!

using Test: @test

using Omics

# ---- #

# 30.025 ns (0 allocations: 0 bytes)
# 53.976 ns (0 allocations: 0 bytes)
# 297.393 ns (0 allocations: 0 bytes)
# 2.343 μs (0 allocations: 0 bytes)

for (um, re) in (
    (10, 6.597957136428492),
    (100, 1.8754776361269154),
    (1000, 0.61731275423233716188797076691194),
    (10000, 0.1964827926939546),
)

    seed!(20240904)

    nu_ = randn(um) * 10.0

    @test isapprox(Omics.Significance.get_margin_of_error(nu_), re)

    #@btime Omics.Significance.get_margin_of_error($nu_)

end

# ---- #

# 291.665 ns (0 allocations: 0 bytes)
# 291.668 ns (0 allocations: 0 bytes)
# 291.665 ns (0 allocations: 0 bytes)
# 297.253 ns (0 allocations: 0 bytes)
# 289.982 ns (0 allocations: 0 bytes)

seed!(20230612)

const NU_ = randn(1000)

for (fr, re) in (
    (0.0, 0.0),
    (0.001, 4.0685463561927655e-5),
    (0.5, 0.021895485060908798),
    (0.95, 0.06362492851958153),
    (1.0, Inf),
)

    @test isapprox(Omics.Significance.get_margin_of_error(NU_, fr), re)

    #@btime Omics.Significance.get_margin_of_error(NU_, $fr)

end

# ---- #

# 2.125 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
# 2.084 ns (0 allocations: 0 bytes)

for (um, re) in ((0, 0.1), (1, 0.1), (2, 0.2))

    @test Omics.Significance.ge(10, um) === re

    #@btime Omics.Significance.ge(10, $um)

end

# ---- #

const N1_ = [-4, -3, -2, -1, -0.0, 0, 1, 2, 3, 4]

const N2_ = [-1, -0.0, 0, 1]

# ---- #

# 144.448 ns (11 allocations: 512 bytes)
# 152.812 ns (11 allocations: 512 bytes)

for (eq, re) in (
    (<=, ([0.4, 0.6, 0.6, 0.7], [0.7, 0.7, 0.7, 0.7])),
    (>=, ([0.7, 0.6, 0.6, 0.4], [0.7, 0.7, 0.7, 0.7])),
)

    @test Omics.Significance.ge(eq, N1_, N2_) == re

    #@btime Omics.Significance.ge($eq, N1_, N2_)

end

# ---- #

# 122.058 ns (6 allocations: 976 bytes)

@test Omics.Significance.ge(Omics.Numbe.separate(N1_)..., Omics.Numbe.separate(N2_)...) ==
      ([1.0], [1.0], [1, 1, 2 / 3], [1.0, 1, 1])

#@btime Omics.Significance.ge(N1_, N2_);
