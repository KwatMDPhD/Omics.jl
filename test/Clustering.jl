using Distances: CorrDist

using Test: @test

using BioLab

# ---- #

const MA = [
    0  1  2  3  10  20  30
    0  2  1  3  20  10  30
    0  1  2  3  10  20  30
    0.1  2  1  3.1  20  10  30.1
]

# ---- #

for (di, re) in ((2, [4, 1, 2, 3, 7, 5, 6]), (1, [1, 3, 2, 4]))

    if isone(di)

        ma = permutedims(MA)

    else

        ma = MA

    end

    @test BioLab.Clustering.hierarchize(ma).order == re

    # 1.704 μs (38 allocations: 4.54 KiB)
    # 1.204 μs (35 allocations: 3.04 KiB)
    @btime BioLab.Clustering.hierarchize($ma)

end

# ---- #

const FU = CorrDist()

# ---- #

@test BioLab.Clustering.hierarchize(MA, FU).order == [3, 6, 2, 5, 7, 1, 4]

# ---- #

# 1.954 μs (47 allocations: 5.29 KiB)
@btime BioLab.Clustering.hierarchize($MA, $FU);

# ---- #

for (k, re) in (
    (1, [1, 1, 1, 1, 1, 1, 1]),
    (2, [1, 1, 2, 1, 1, 2, 1]),
    (3, [1, 2, 3, 1, 2, 3, 1]),
    (4, [1, 2, 3, 1, 2, 3, 4]),
)

    hc = BioLab.Clustering.hierarchize(MA, FU)

    @test BioLab.Clustering.cluster(hc, k) == re

    # 455.371 ns (17 allocations: 1.25 KiB)
    # 427.136 ns (16 allocations: 1.22 KiB)
    # 389.851 ns (15 allocations: 1.16 KiB)
    # 337.516 ns (13 allocations: 1.05 KiB)
    @btime BioLab.Clustering.cluster($hc, $k)

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

    @test BioLab.Clustering.order(co_, ma) == re

    # 2.708 μs (86 allocations: 7.38 KiB)
    # 2.681 μs (86 allocations: 7.38 KiB)
    # 2.681 μs (86 allocations: 7.38 KiB)
    # 2.713 μs (86 allocations: 7.38 KiB)
    # 2.727 μs (86 allocations: 7.38 KiB)
    # 2.690 μs (86 allocations: 7.38 KiB)
    @btime BioLab.Clustering.order($co_, $ma)

end
