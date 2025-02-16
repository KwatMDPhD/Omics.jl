using Distances: CorrDist, Euclidean

using Random: seed!

using Test: @test

using Omics

# ---- #

for (n1_, n2_, re) in (
    ([1, 2], [1, 2], 0.0),
    ([1, 2], [2, 1], 2.0),
    ([1, 2, 3], [1, 2, 3], 0.0),
    ([1, 2, 3], [3, 2, 1], 2.0),
)

    @test Omics.Distance.Information()(n1_, n2_) === re

end

# ---- #

# 4.250 ns (0 allocations: 0 bytes)
# 41.792 ns (4 allocations: 288 bytes)
# 28.166 μs (54 allocations: 43.98 KiB)
# 16.491 ns (0 allocations: 0 bytes)
# 103.522 ns (4 allocations: 1.81 KiB)
# 32.458 μs (54 allocations: 45.52 KiB)
# 149.038 ns (0 allocations: 0 bytes)
# 733.598 ns (6 allocations: 15.88 KiB)
# 79.916 μs (57 allocations: 59.59 KiB)
# 1.913 μs (0 allocations: 0 bytes)
# 6.139 μs (6 allocations: 156.38 KiB)
# 1.031 ms (57 allocations: 200.09 KiB)

for um in (10, 100, 1000, 10000)

    seed!(20241015)

    n1_ = randn(um)

    n2_ = randn(um)

    #@btime Euclidean()($n1_, $n2_)

    #@btime CorrDist()($n1_, $n2_)

    #@btime Omics.Distance.Information()($n1_, $n2_)

end

# ---- #

# 2.416 ns (0 allocations: 0 bytes)
# 2.416 ns (0 allocations: 0 bytes)
# 2.375 ns (0 allocations: 0 bytes)
# 2.375 ns (0 allocations: 0 bytes)

const P1 = pi * 0.1

for (a1, a2, re) in
    ((0.0, P1, P1), (0.0, pi, float(pi)), (0.0, pi + P1, pi - P1), (0.0, 2.0 * pi, 0.0))

    po = Omics.Distance.Polar()

    @test po(a1, a2) === po(a2, a1) === re

    #@btime $po($a1, $a2)

end
