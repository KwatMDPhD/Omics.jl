using Distances: CorrDist

using Test: @test

using BioLab

# ---- #

const MA = [
    0 0 0 0.1
    1 2 1 2
    2 1 2 1
    3 3 3 3.1
    10 20 10 20
    20 10 20 10
    30 30 30 30.1
]

# ---- #

@test BioLab.Clustering.hierarchize(MA, 1).order == [4, 1, 2, 3, 7, 5, 6]

@test BioLab.Clustering.hierarchize(MA, 2).order == [1, 3, 2, 4]

@test BioLab.Clustering.hierarchize(MA, 1).order ==
      BioLab.Clustering.hierarchize(permutedims(MA), 2).order

# ---- #

const FU = CorrDist()

@test BioLab.Clustering.hierarchize(MA, 1; fu = FU).order == [3, 6, 2, 5, 7, 1, 4]

# ---- #

for (k, re) in (
    (1, [1, 1, 1, 1, 1, 1, 1]),
    (2, [1, 1, 2, 1, 1, 2, 1]),
    (3, [1, 2, 3, 1, 2, 3, 1]),
    (4, [1, 2, 3, 1, 2, 3, 4]),
)

    @test BioLab.Clustering.cluster(BioLab.Clustering.hierarchize(MA, 1), k) ==
          BioLab.Clustering.cluster(BioLab.Clustering.hierarchize(permutedims(MA), 2), k)

    @test BioLab.Clustering.cluster(BioLab.Clustering.hierarchize(MA, 1; fu = FU), k) == re

end
