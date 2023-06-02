include("environment.jl")

# ---- #

te = joinpath(tempdir(), "BioLab.test.MatrixFactorization")

BioLab.Path.empty(te)

function is_all_positive(ma)

    return all(0 <= nu for nu in ma)

end

# ---- #

for (n_ro, n_co, n_fa) in ((4, 3, 2), (8, 16, 3))

    st = "$n_ro x $n_co @ $n_fa"

    BioLab.print_header(st)

    ama = BioLab.Matrix.simulate(n_ro, n_co, "rand")

    display(ama)

    di = mkdir(joinpath(te, st))

    wma, hma = BioLab.MatrixFactorization.factorize(ama, n_fa; di)

    @test size(wma) == (n_ro, n_fa) && is_all_positive(wma)

    @test size(hma) == (n_fa, n_co) && is_all_positive(hma)

    @test wma == BioLab.DataFrame.separate(
        BioLab.Table.read(joinpath(di, "row1_x_factor_x_positive.tsv")),
    )[4]

    @test hma == BioLab.DataFrame.separate(
        BioLab.Table.read(joinpath(di, "factor_x_column1_x_positive.tsv")),
    )[4]

    # @code_warntype BioLab.MatrixFactorization.factorize(ama, n_fa; di)

    # 13.750 μs (17 allocations: 1.44 KiB)
    # 452.375 μs (17 allocations: 4.16 KiB)
    # @btime BioLab.MatrixFactorization.factorize($ama, $n_fa; ve = $false)

end

# ---- #

n_ro = 7

n_co = 9

n_fa = 3

ama = BioLab.Matrix.simulate(n_ro, n_co, "rand")

wma, hma = BioLab.MatrixFactorization.factorize(ama, n_fa; ve = false)

hma2 = BioLab.MatrixFactorization.solve_h(ama, wma)

display(hma)

display(hma2)

BioLab.MatrixFactorization.plot((wma,), (hma, hma2))

@test isapprox(hma, hma2; atol = 0.3)

# @code_warntype BioLab.MatrixFactorization.solve_h(ama, wma)

# 3.557 μs (23 allocations: 4.03 KiB)
# @btime BioLab.MatrixFactorization.solve_h($ama, $wma)
