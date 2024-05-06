using Test: @test

using Nucleus

# ---- #

using Distances: CorrDist, Euclidean, pairwise

# ---- #

const MA = [
    0  1  2  3  10  20  30
    0  2  1  3  20  10  30
    0  1  2  3  10  20  30
    0.1  2  1  3.1  20  10  30.1
]

# ---- #

for (ea, re) in ((eachcol, [4, 1, 2, 3, 7, 5, 6]), (eachrow, [1, 3, 2, 4]))

    nu___ = ea(MA)

    di = pairwise(Euclidean(), nu___)

    @test Nucleus.Clustering.hierarchize(di).order ==
          Nucleus.Clustering.hierarchize(Euclidean(), nu___).order ==
          re

    # 1.333 μs (35 allocations: 3.86 KiB)
    # 1.421 μs (36 allocations: 4.30 KiB)
    # 913.194 ns (32 allocations: 2.62 KiB)
    # 977.538 ns (33 allocations: 2.81 KiB)

    #@btime Nucleus.Clustering.hierarchize($di)

    #@btime Nucleus.Clustering.hierarchize(Euclidean(), $nu___)

end

# ---- #

for (co_, ma, re) in (
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

    @test Nucleus.Clustering.order(Euclidean(), co_, nu___) == re

    # 2.292 μs (80 allocations: 6.67 KiB)
    # 2.292 μs (80 allocations: 6.67 KiB)
    # 2.310 μs (80 allocations: 6.67 KiB)
    # 2.292 μs (80 allocations: 6.67 KiB)
    # 2.301 μs (80 allocations: 6.67 KiB)
    # 2.292 μs (80 allocations: 6.67 KiB)
    #@btime Nucleus.Clustering.order(Euclidean(), $co_, $nu___)

end

# ---- #

const IT_ = [1, 2, 3, 1, 2, 3, 1]

# ---- #

for (fu, re) in (
    (Euclidean(), 0.28193356790024415),
    (CorrDist(), 1.0),
    (Nucleus.Distance.InformationDistance(), 1.0),
)

    @test Nucleus.Clustering.compare_grouping(
        Nucleus.Clustering.hierarchize(fu, eachcol(MA)),
        "",
        IT_;
        text = "Mutual Information $fu",
    ) === re

end

# ---- #

for (fu, re) in
    ((Euclidean(), 0.0), (CorrDist(), 1.0), (Nucleus.Distance.InformationDistance(), 1.0))

    @test Nucleus.Clustering.compare_grouping(
        Nucleus.Clustering.hierarchize(fu, eachcol(MA)),
        "",
        (it -> "Label $it").(IT_),
        1;
        text = "Tight $fu",
    ) === re

end
