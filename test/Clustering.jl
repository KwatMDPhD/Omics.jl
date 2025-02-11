using Distances: Euclidean, pairwise

using Test: @test

using Omics

# ---- #

const AN = [
    0 1 2 3 10 20 30 40
    0 2 1 3 20 10 30 40
    0 1 2 3 10 20 30 40
    0.1 2 1 3.1 20 10 30.1 40.1
    0.2 2 1 3.2 20 10 30.2 40.2
    0.3 2 1 3.3 20 10 30.3 40.3
]

for (fu, re) in ((eachcol, [1, 3, 2, 4, 6, 5, 7, 8]), (eachrow, [1, 3, 2, 4, 5, 6]))

    @test Omics.Clustering.hierarchize(pairwise(Euclidean(), fu(AN))).order == re

end

# ---- #

# 2.093 μs (146 allocations: 8.28 KiB)
# 2.116 μs (146 allocations: 8.28 KiB)
# 2.069 μs (146 allocations: 8.28 KiB)
# 2.088 μs (146 allocations: 8.28 KiB)
# 2.079 μs (146 allocations: 8.28 KiB)
# 2.106 μs (146 allocations: 8.28 KiB)

for (gr_, an, re) in (
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

    an___ = eachcol(an)

    @test Omics.Clustering.order(Euclidean(), gr_, an___) == re

    #@btime Omics.Clustering.order(Euclidean(), $gr_, $an___)

end
