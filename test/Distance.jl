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

    # 3.375 ns (0 allocations: 0 bytes)
    # 37.215 ns (4 allocations: 160 bytes)
    # 11.011 ns (0 allocations: 0 bytes)
    # 3.375 ns (0 allocations: 0 bytes)
    # 37.256 ns (4 allocations: 160 bytes)
    # 11.094 ns (0 allocations: 0 bytes)
    # 4.541 ns (0 allocations: 0 bytes)
    # 40.028 ns (4 allocations: 160 bytes)
    # 12.178 ns (0 allocations: 0 bytes)
    # 4.583 ns (0 allocations: 0 bytes)
    # 40.028 ns (4 allocations: 160 bytes)
    # 12.220 ns (0 allocations: 0 bytes)
    # 3.625 ns (0 allocations: 0 bytes)
    # 40.994 ns (4 allocations: 192 bytes)
    # 13.221 ns (0 allocations: 0 bytes)
    # 3.666 ns (0 allocations: 0 bytes)
    # 40.994 ns (4 allocations: 192 bytes)
    # 13.221 ns (0 allocations: 0 bytes)

    #@btime EU($n1_, $n2_)

    #@btime CO($n1_, $n2_)

    #@btime IR($n1_, $n2_)

end

# ---- #

for ur in (10, 100, 1000, 10000)

    seed!(20241015)

    n1_ = randn(ur)

    n2_ = randn(ur)

    # 4.250 ns (0 allocations: 0 bytes)
    # 45.960 ns (4 allocations: 288 bytes)
    # 28.125 μs (54 allocations: 43.98 KiB)
    # 16.825 ns (0 allocations: 0 bytes)
    # 104.254 ns (4 allocations: 1.81 KiB)
    # 32.417 μs (54 allocations: 45.52 KiB)
    # 149.037 ns (0 allocations: 0 bytes)
    # 725.697 ns (6 allocations: 15.88 KiB)
    # 80.583 μs (57 allocations: 59.59 KiB)
    # 1.917 μs (0 allocations: 0 bytes)
    # 6.208 μs (6 allocations: 156.38 KiB)
    # 1.039 ms (57 allocations: 200.09 KiB)

    #@btime EU($n1_, $n2_)

    #@btime CO($n1_, $n2_)

    #@btime IR($n1_, $n2_)

end
