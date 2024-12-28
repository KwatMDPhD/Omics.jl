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
# 44.949 ns (4 allocations: 288 bytes)
# 29.375 μs (54 allocations: 43.98 KiB)
# 16.825 ns (0 allocations: 0 bytes)
# 104.300 ns (4 allocations: 1.81 KiB)
# 33.584 μs (54 allocations: 45.52 KiB)
# 149.075 ns (0 allocations: 0 bytes)
# 726.636 ns (6 allocations: 15.88 KiB)
# 81.125 μs (57 allocations: 59.59 KiB)
# 1.921 μs (0 allocations: 0 bytes)
# 6.236 μs (6 allocations: 156.38 KiB)
# 1.038 ms (57 allocations: 200.09 KiB)
for ur in (10, 100, 1000, 10000)

    seed!(20241015)

    n1_ = randn(ur)

    n2_ = randn(ur)

    #@btime EU($n1_, $n2_)

    #@btime CO($n1_, $n2_)

    #@btime IR($n1_, $n2_)

end
