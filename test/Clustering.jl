using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Distances: Euclidean

# ---- #

const MA = [
    0 1 2 3 10 20 30
    0 2 1 3 20 10 30
    0 1 2 3 10 20 30
    0.1 2 1 3.1 20 10 30.1
]

for (ea, re) in ((eachcol, [4, 1, 2, 3, 7, 5, 6]), (eachrow, [1, 3, 2, 4]))

    @test Omics.Clustering.hierarchize(
        Omics.Clustering.pairwise(Euclidean(), ea(MA)),
    ).order == re

end

# ---- #

# 1.866 μs (128 allocations: 7.19 KiB)
# 1.907 μs (128 allocations: 7.19 KiB)
# 1.893 μs (128 allocations: 7.19 KiB)
# 1.870 μs (128 allocations: 7.19 KiB)
# 1.829 μs (128 allocations: 7.19 KiB)
# 1.866 μs (128 allocations: 7.19 KiB)
for (la_, ma, re) in (
    (
        [1, 1, 1, 1, 2, 2, 2, 2],
        [
            1 2 3 4 1 2 3 4
            1 2 3 4 1 2 3 4
        ],
        [1, 2, 3, 4, 5, 6, 7, 8],
    ),
    (
        [2, 2, 2, 2, 1, 1, 1, 1],
        [
            1 2 3 4 1 2 3 4
            1 2 3 4 1 2 3 4
        ],
        [5, 6, 7, 8, 1, 2, 3, 4],
    ),
    (
        [1, 1, 1, 1, 2, 2, 2, 2],
        [
            1 2 1 2 1 2 1 2
            1 2 1 2 1 2 1 2
        ],
        [1, 3, 2, 4, 5, 7, 6, 8],
    ),
    (
        [2, 2, 2, 2, 1, 1, 1, 1],
        [
            1 2 1 2 1 2 1 2
            1 2 1 2 1 2 1 2
        ],
        [5, 7, 6, 8, 1, 3, 2, 4],
    ),
    (
        [1, 2, 1, 2, 1, 2, 1, 2],
        [
            1 1 2 2 1 1 2 2
            1 1 2 2 1 1 2 2
        ],
        [1, 5, 3, 7, 2, 6, 4, 8],
    ),
    (
        [2, 1, 2, 1, 2, 1, 2, 1],
        [
            1 1 2 2 1 1 2 2
            1 1 2 2 1 1 2 2
        ],
        [2, 6, 4, 8, 1, 5, 3, 7],
    ),
)

    nu___ = eachcol(ma)

    @test Omics.Clustering.order(Euclidean(), la_, nu___) == re

    #@btime Omics.Clustering.order(Euclidean(), $la_, $nu___)

end
