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

    # 1.346 μs (35 allocations: 3.86 KiB)
    # 1.462 μs (36 allocations: 4.30 KiB)
    # 938.435 ns (32 allocations: 2.62 KiB)
    # 995.800 ns (33 allocations: 2.81 KiB)

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

    # 2.472 μs (80 allocations: 6.67 KiB)
    # 2.477 μs (80 allocations: 6.67 KiB)
    # 2.468 μs (80 allocations: 6.67 KiB)
    # 2.477 μs (80 allocations: 6.67 KiB)
    # 2.481 μs (80 allocations: 6.67 KiB)
    # 2.486 μs (80 allocations: 6.67 KiB)
    #@btime Nucleus.Clustering.order(Nucleus.Distance.EU, $co_, $nu___)

end

# ---- #

const IT_ = [1, 2, 3, 1, 2, 3, 1]

# ---- #

@test Nucleus.Clustering.compare_grouping(
    Nucleus.Distance.CO,
    "",
    IT_,
    MA;
    ti = "Mutual Information",
) === 0.5590872654876136

# ---- #

@test Nucleus.Clustering.compare_grouping(
    Nucleus.Distance.CO,
    "",
    (it -> "Label $it").(IT_),
    MA,
    1;
    ti = "Tight",
) === 1.0
