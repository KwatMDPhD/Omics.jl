include("environment.jl")

# ---- #

ma = [
    0 0 0 0.1
    1 2 1 2
    2 1 2 1
    3 3 3 3.1
    10 20 10 20
    20 10 20 10
    30 30 30 30.1
]

@test BioLab.Clustering.hierarchize(ma, 1).order == [4, 1, 2, 3, 7, 5, 6]

@test BioLab.Clustering.hierarchize(ma, 1; fu = BioLab.Clustering.CorrDist()).order ==
      [3, 6, 2, 5, 7, 1, 4]

@test BioLab.Clustering.hierarchize(ma, 2).order == [1, 3, 2, 4]

@test BioLab.Clustering.hierarchize(ma, 1).order ==
      BioLab.Clustering.hierarchize(permutedims(ma), 2).order

# ---- #

ma = [
    0 0 0 0.1
    1 2 1 2
    2 1 2 1
    3 3 3 3.1
    10 20 10 20
    20 10 20 10
    30 30 30 30.1
]

fu = BioLab.Clustering.CorrDist()

for (k, gr_) in (
    (1, [1, 1, 1, 1, 1, 1, 1]),
    (2, [1, 1, 2, 1, 1, 2, 1]),
    (3, [1, 2, 3, 1, 2, 3, 1]),
    (4, [1, 2, 3, 1, 2, 3, 4]),
)

    @test BioLab.Clustering.cluster(BioLab.Clustering.hierarchize(ma, 1; fu), k) == gr_

end

# ---- #

ma = rand(16, 2)

k = 4

@test BioLab.Clustering.cluster(BioLab.Clustering.hierarchize(ma, 1), k) ==
      BioLab.Clustering.cluster(BioLab.Clustering.hierarchize(permutedims(ma), 2), k)
