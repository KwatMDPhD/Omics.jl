include("environment.jl")

# ---- #

for (n_ro, n_co, n_fa) in ((4, 3, 2), (8, 16, 3))

    st = "$n_ro x $n_co --> $n_fa"

    ama = rand(n_ro, n_co)

    wma, hma = BioLab.MatrixFactorization.factorize(ama, n_fa)

    @test size(wma) == (n_ro, n_fa)

    @test size(hma) == (n_fa, n_co)

    BioLab.NumberArray.error_negative(wma)

    BioLab.NumberArray.error_negative(hma)

    di = mkdir(joinpath(TE, BioLab.Time.stamp()))

    BioLab.MatrixFactorization.write(di, (wma,), (hma,))

    @test wma == BioLab.DataFrame.separate(
        BioLab.Table.read(joinpath(di, "row1_x_factor_x_positive.tsv")),
    )[4]

    @test hma == BioLab.DataFrame.separate(
        BioLab.Table.read(joinpath(di, "factor_x_column1_x_positive.tsv")),
    )[4]

end

# ---- #

n_ro = 7

n_co = 9

n_fa = 3

ama = rand(n_ro, n_co)

# ---- #

wma, hma = BioLab.MatrixFactorization.factorize(ama, n_fa)

hma2 = BioLab.MatrixFactorization.solve_h(ama, wma)

# TODO: Solve better.
@test isapprox(hma, hma2; rtol = 1)

# ---- #

@test @is_error BioLab.MatrixFactorization.write("", (wma,), (hma, hma2))

BioLab.MatrixFactorization.write(TE, (wma,), (hma, hma2))
