using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Distances: CorrDist, Euclidean

using Random: seed!

# ---- #

const EU = Euclidean()

const CO = CorrDist()

const IR = Omics.Distance.Information()

# ---- #

for (n1_, n2_, re) in (
    ([1, 2], [1, 2], 0.0),
    ([1, 2], [2, 1], 2.0),
    ([1, 2, 3], [1, 2, 3], 0.0),
    ([1, 2, 3], [3, 2, 1], 2.0),
    ([1, 2, 3, 4], [1, 2, 3, 4], 0.0),
    ([1, 2, 3, 4], [4, 3, 2, 1], 2.0),
)

    @test IR(n1_, n2_) === re

end

# ---- #

# 4.250 ns (0 allocations: 0 bytes)
# 45.033 ns (4 allocations: 288 bytes)
# 29.291 μs (54 allocations: 43.98 KiB)
# 16.825 ns (0 allocations: 0 bytes)
# 103.059 ns (4 allocations: 1.81 KiB)
# 33.500 μs (54 allocations: 45.52 KiB)
# 149.012 ns (0 allocations: 0 bytes)
# 720.107 ns (6 allocations: 15.88 KiB)
# 81.250 μs (57 allocations: 59.59 KiB)
# 1.917 μs (0 allocations: 0 bytes)
# 6.070 μs (6 allocations: 156.38 KiB)
# 1.035 ms (57 allocations: 200.09 KiB)
for ur in (10, 100, 1000, 10000)

    seed!(20241015)

    n1_ = randn(ur)

    n2_ = randn(ur)

    #@btime EU($n1_, $n2_)

    #@btime CO($n1_, $n2_)

    #@btime IR($n1_, $n2_)

end
