using Distances

include("_.jl")

# --------------------------------------------- #

ro_x_co_x_nu = [
    0 0 0 0.1
    1 2 1 2
    2 1 2 1
    3 3 3 3.1
    10 20 10 20
    20 10 20 10
    30 30 30 30.1
]

hi = BioLab.Clustering.hierarchize(ro_x_co_x_nu, 2)

display(fieldnames(typeof(hi)))

@test hi.order == [1, 3, 2, 4]

@test BioLab.Clustering.hierarchize(ro_x_co_x_nu, 1).order == [4, 1, 2, 3, 7, 5, 6]

@test BioLab.Clustering.hierarchize(ro_x_co_x_nu, 1; fu = CorrDist()).order ==
      [3, 6, 2, 5, 7, 1, 4]

ro_x_co_x_nu = rand(79, 81)

@test BioLab.Clustering.hierarchize(ro_x_co_x_nu, 1).order ==
      BioLab.Clustering.hierarchize(permutedims(ro_x_co_x_nu), 2).order

ma = rand(70, 4)

for (ma, di) in ((ma, 1), (permutedims(ma), 2))

    BioLab.print_header("$di $(size(ma)[di])")

    # @code_warntype BioLab.Clustering.hierarchize(ma, di)

    # 39.292 μs (150 allocations: 144.20 KiB)
    # 38.834 μs (149 allocations: 141.89 KiB)
    # @btime BioLab.Clustering.hierarchize($ma, $di)

end

# --------------------------------------------- #

ro_x_co_x_nu = [
    0 0 0 0.1
    1 2 1 2
    2 1 2 1
    3 3 3 3.1
    10 20 10 20
    20 10 20 10
    30 30 30 30.1
]

fu = CorrDist()

for (n, gr_) in (
    (1, [1, 1, 1, 1, 1, 1, 1]),
    (2, [1, 1, 2, 1, 1, 2, 1]),
    (3, [1, 2, 3, 1, 2, 3, 1]),
    (4, [1, 2, 3, 1, 2, 3, 4]),
)

    @test BioLab.Clustering.cluster(BioLab.Clustering.hierarchize(ro_x_co_x_nu, 1; fu), n) == gr_

end

ro_x_co_x_nu = rand(79, 81)

n = 4

@test BioLab.Clustering.cluster(BioLab.Clustering.hierarchize(ro_x_co_x_nu, 1), n) ==
      BioLab.Clustering.cluster(BioLab.Clustering.hierarchize(permutedims(ro_x_co_x_nu), 2), n)

ma = rand(79, 81)

n = 4

for (ma, di) in ((ma, 1), (permutedims(ma), 2))

    BioLab.print_header("$di $(size(ma)[di])")

    hi = BioLab.Clustering.hierarchize(ma, di)

    # @code_warntype BioLab.Clustering.cluster(hi, n)

    # 3.016 μs (81 allocations: 11.30 KiB)
    # 3.016 μs (81 allocations: 11.30 KiB)
    # @btime BioLab.Clustering.cluster($hi, $n)

end
