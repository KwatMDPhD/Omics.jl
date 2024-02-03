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

    nu___ = ea(MA)

    di = Nucleus.Distance.pairwise(Nucleus.Distance.EU, nu___)

    @test Nucleus.Clustering.hierarchize(di).order ==
          Nucleus.Clustering.hierarchize(Nucleus.Distance.EU, nu___).order ==
          re

    # 1.333 μs (35 allocations: 3.86 KiB)
    # 1.421 μs (36 allocations: 4.30 KiB)
    # 913.194 ns (32 allocations: 2.62 KiB)
    # 977.538 ns (33 allocations: 2.81 KiB)

    #@btime Nucleus.Clustering.hierarchize($di)

    #@btime Nucleus.Clustering.hierarchize(Nucleus.Distance.EU, $nu___)

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

    @test Nucleus.Clustering.order(Nucleus.Distance.EU, co_, nu___) == re

    # 2.292 μs (80 allocations: 6.67 KiB)
    # 2.292 μs (80 allocations: 6.67 KiB)
    # 2.310 μs (80 allocations: 6.67 KiB)
    # 2.292 μs (80 allocations: 6.67 KiB)
    # 2.301 μs (80 allocations: 6.67 KiB)
    # 2.292 μs (80 allocations: 6.67 KiB)
    #@btime Nucleus.Clustering.order(Nucleus.Distance.EU, $co_, $nu___)

end

# ---- #

const IT_ = [1, 2, 3, 1, 2, 3, 1]

# ---- #

for (fu, re) in (
    (Nucleus.Distance.EU, 0.09928735617366401),
    (Nucleus.Distance.CO, 0.5711294801431482),
    (Nucleus.Distance.IN, 0.5917316471029412),
)

    @test Nucleus.Clustering.compare_grouping(fu, "", IT_, MA; ti = "Mutual Information $fu") ===
          re

end

# ---- #

for (fu, re) in
    ((Nucleus.Distance.EU, 0.0), (Nucleus.Distance.CO, 1.0), (Nucleus.Distance.IN, 1.0))

    @test Nucleus.Clustering.compare_grouping(
        fu,
        "",
        (it -> "Label $it").(IT_),
        MA,
        1;
        ti = "Tight $fu",
    ) === re

end
