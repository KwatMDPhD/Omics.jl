using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Distances: CorrDist, Euclidean

using Random: seed!

# ---- #

const EU = Euclidean()

const CO = CorrDist()

const IR = Omics.Distance.InformationDistance()

# ---- #

for (n1_, n2_, re) in (
    ([1, 2], [1, 2], 0.0),
    ([1, 2], [2, 1], 2.0),
    ([1, 2, 3], [1, 2, 3], 0.0),
    ([1, 2, 3], [3, 2, 1], 2.0),
    ([1, 2, 3, 4], [1, 2, 3, 4], 0.0),
    ([1, 2, 3, 4], [4, 3, 2, 1], 2.0),
)

    ir = IR(n1_, n2_)

    @test ir === re

    @test isapprox(ir, CO(n1_, n2_); atol = 1e-15)

end

# ---- #

# 4.291 ns (0 allocations: 0 bytes)
# 44.655 ns (4 allocations: 288 bytes)
# 28.292 μs (54 allocations: 43.98 KiB)
# 16.533 ns (0 allocations: 0 bytes)
# 102.592 ns (4 allocations: 1.81 KiB)
# 32.334 μs (54 allocations: 45.52 KiB)
# 149.037 ns (0 allocations: 0 bytes)
# 723.595 ns (6 allocations: 15.88 KiB)
# 80.000 μs (57 allocations: 59.59 KiB)
# 1.921 μs (0 allocations: 0 bytes)
# 7.709 μs (6 allocations: 156.38 KiB)
# 1.033 ms (57 allocations: 200.09 KiB)
for ur in (10, 100, 1000, 10000)

    seed!(20241015)

    n1_ = randn(ur)

    n2_ = randn(ur)

    #@btime EU($n1_, $n2_)

    #@btime CO($n1_, $n2_)

    #@btime IR($n1_, $n2_)

end
