using Test: @test

using BioLab

# ---- #

const FU = >=(0)

for (n_ro, n_co, n_fa) in ((4, 3, 2), (8, 16, 3))

    maa = rand(n_ro, n_co)

    maw, mah = BioLab.MatrixFactorization.factorize(maa, n_fa; maxiter = 10^6)

    @test size(maw) == (n_ro, n_fa)

    @test size(mah) == (n_fa, n_co)

    @test all(FU, maw)

    @test all(FU, mah)

    @test BioLab.Error.@is_error BioLab.MatrixFactorization.write("", (maw,), (mah,))

    di = BioLab.Path.remake_directory(joinpath(BioLab.TE, "$n_ro $n_co $n_fa"))

    @test BioLab.MatrixFactorization.write(di, (maw,), (mah,)) == di

    @test maw ==
          Matrix(BioLab.DataFrame.read(joinpath(di, "row1_x_factor_x_positive.tsv"))[!, 2:end])

    @test mah ==
          Matrix(BioLab.DataFrame.read(joinpath(di, "factor_x_column1_x_positive.tsv"))[!, 2:end])

end

# ---- #

const MAA = rand(7, 9)

const MAW, MAH = BioLab.MatrixFactorization.factorize(MAA, 3; maxiter = 10^3)

const MAH2 = BioLab.MatrixFactorization.solve_h(MAA, MAW)

@test isapprox(MAH, MAH2; rtol = 1e-0)

BioLab.MatrixFactorization.write(BioLab.TE, (MAW,), (MAH, MAH2))
