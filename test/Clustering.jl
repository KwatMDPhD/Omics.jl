using Test: @test

using Nucleus

# ---- #

using Distances: CorrDist

# ---- #

for (nu___, re) in (
    (
        ([1], [1]),
        [
            0 0
            0 0
        ],
    ),
    (
        ([1], [2]),
        [
            0 1
            1 0
        ],
    ),
    (
        ([1], [2], [4]),
        [
            0 1 9
            1 0 4
            9 4 0
        ],
    ),
    (
        ([1], [4], [2]),
        [
            0 9 1
            9 0 4
            1 4 0
        ],
    ),
    (
        ([1, 2], [2, 1]),
        [
            0 2
            2 0
        ],
    ),
)

    @test Nucleus.Clustering.get_distance(nu___, SqEuclidean()) == re

end

# ---- #

const MA = [
    0  1  2  3  10  20  30
    0  2  1  3  20  10  30
    0  1  2  3  10  20  30
    0.1  2  1  3.1  20  10  30.1
]

# ---- #

for (ea, re) in ((eachcol, [4, 1, 2, 3, 7, 5, 6]), (eachrow, [1, 3, 2, 4]))

    ea_ = ea(MA)

    @test Nucleus.Clustering.hierarchize(ea_).order == re

    # 1.446 μs (36 allocations: 4.30 KiB)
    # 987.500 ns (33 allocations: 2.81 KiB)
    @btime Nucleus.Clustering.hierarchize($ea_)

end

# ---- #

for (fu, re) in (
    (CorrDist(), [3, 6, 2, 5, 7, 1, 4]),
    ((nu1_, nu2_) -> (sqrt.(nu1_ .^ 2 .+ nu2_ .^ 2)), [4, 1, 2, 3, 7, 5, 6]),
)

    @test Nucleus.Clustering.hierarchize(MA, fu).order == re

    # 1.954 μs (47 allocations: 5.29 KiB)
    @btime Nucleus.Clustering.hierarchize(MA, $fu)

end

# ---- #

for (k, re) in (
    (1, [1, 1, 1, 1, 1, 1, 1]),
    (2, [1, 1, 2, 1, 1, 2, 1]),
    (3, [1, 2, 3, 1, 2, 3, 1]),
    (4, [1, 2, 3, 1, 2, 3, 4]),
)

    hc = Nucleus.Clustering.hierarchize(MA, FU)

    @test Nucleus.Clustering.cluster(hc, k) == re

    # 455.371 ns (17 allocations: 1.25 KiB)
    # 427.136 ns (16 allocations: 1.22 KiB)
    # 389.851 ns (15 allocations: 1.16 KiB)
    # 337.516 ns (13 allocations: 1.05 KiB)
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

    @test Nucleus.Clustering.order(co_, ma) == re

    # 2.667 μs (86 allocations: 7.38 KiB)
    # 2.681 μs (86 allocations: 7.38 KiB)
    # 2.681 μs (86 allocations: 7.38 KiB)
    # 2.694 μs (86 allocations: 7.38 KiB)
    # 2.685 μs (86 allocations: 7.38 KiB)
    # 2.690 μs (86 allocations: 7.38 KiB)
    #@btime Nucleus.Clustering.order($co_, $ma)

end
