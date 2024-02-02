using Test: @test

using Nucleus

# ---- #

const MA = [
    0  1  2  3  10  20  30
    0  2  1  3  20  10  30
    0  1  2  3  10  20  30
    0.1  2  1  3.1  20  10  30.1
]

# ---- #

for (ea, re) in ((eachcol, [4, 1, 2, 3, 7, 5, 6]), (eachrow, [1, 3, 2, 4]))

    di = Nucleus.Distance.pairwise(Nucleus.Distance.EU, ea(MA))

    @test Nucleus.Clustering.hierarchize(di).order == re

    # 1.367 μs (35 allocations: 3.86 KiB)
    # 956.250 ns (32 allocations: 2.62 KiB)
    #@btime Nucleus.Clustering.hierarchize($di)

end

# ---- #

for (k, re) in (
    (1, [1, 1, 1, 1, 1, 1, 1]),
    (2, [1, 1, 2, 1, 1, 2, 1]),
    (3, [1, 2, 3, 1, 2, 3, 1]),
    (4, [1, 2, 3, 1, 2, 3, 4]),
)

    hc = Nucleus.Clustering.hierarchize(Nucleus.Distance.pairwise(Nucleus.Distance.CO, MA))

    @test Nucleus.Clustering.cluster(hc, k) == re

    # 449.076 ns (17 allocations: 1.25 KiB)
    # 421.482 ns (16 allocations: 1.22 KiB)
    # 385.728 ns (15 allocations: 1.16 KiB)
    # 334.842 ns (13 allocations: 1.05 KiB)
    #@btime Nucleus.Clustering.cluster($hc, $k)

end

# ---- #

for (co_, ma, re) in (
    ([1, 1, 1, 1, 2, 2, 2, 2], [1 2 3 4 1 2 3 4; 1 2 3 4 1 2 3 4], [1, 2, 3, 4, 5, 6, 7, 8]),
    ([2, 2, 2, 2, 1, 1, 1, 1], [1 2 3 4 1 2 3 4; 1 2 3 4 1 2 3 4], [5, 6, 7, 8, 1, 2, 3, 4]),
    ([1, 1, 1, 1, 2, 2, 2, 2], [1 2 1 2 1 2 1 2; 1 2 1 2 1 2 1 2], [1, 3, 2, 4, 5, 7, 6, 8]),
    ([2, 2, 2, 2, 1, 1, 1, 1], [1 2 1 2 1 2 1 2; 1 2 1 2 1 2 1 2], [5, 7, 6, 8, 1, 3, 2, 4]),
    ([1, 2, 1, 2, 1, 2, 1, 2], [1 1 2 2 1 1 2 2; 1 1 2 2 1 1 2 2], [1, 5, 3, 7, 2, 6, 4, 8]),
    ([2, 1, 2, 1, 2, 1, 2, 1], [1 1 2 2 1 1 2 2; 1 1 2 2 1 1 2 2], [2, 6, 4, 8, 1, 5, 3, 7]),
)

    @test Nucleus.Clustering.order(Nucleus.Distance.EU, co_, ma) == re

    # 2.370 μs (80 allocations: 6.67 KiB)
    # 2.380 μs (80 allocations: 6.67 KiB)
    # 2.380 μs (80 allocations: 6.67 KiB)
    # 2.389 μs (80 allocations: 6.67 KiB)
    # 2.384 μs (80 allocations: 6.67 KiB)
    # 2.384 μs (80 allocations: 6.67 KiB)
    #@btime Nucleus.Clustering.order(Nucleus.Distance.EU, $co_, $ma)

end
