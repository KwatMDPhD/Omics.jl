using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

for (n_ro, n_co, n_fa) in ((4, 3, 2), (8, 16, 3), (20, 2000, 10), (1000, 100, 10))

    seed!(20230928)

    ma = rand(n_ro, n_co)

    mw, mh = Nucleus.MatrixFactorization.factorize(ma, n_fa)

    @test size(mw) === (n_ro, n_fa)

    @test size(mh) === (n_fa, n_co)

    for ma in (mw, mh)

        @test all(!Nucleus.Number.is_negative, ma)

    end

    di = Nucleus.Path.establish(joinpath(Nucleus.TE, "$(n_ro)_$(n_co)_$(n_fa)"))

    Nucleus.MatrixFactorization.write(di, mw)

    Nucleus.MatrixFactorization.write(di, mh)

    mh2 = Nucleus.MatrixFactorization.solve_h(mw, ma)

    @test isapprox(mh, mh2; rtol = 1e-3)

    Nucleus.MatrixFactorization.write(Nucleus.Path.establish("$(di)_solved"), mh2; na = "Solved")

    # 11.875 μs (68 allocations: 7.77 KiB)
    # 931.034 ns (19 allocations: 1.61 KiB)
    # 227.667 μs (136 allocations: 41.09 KiB)
    # 3.958 μs (28 allocations: 6.91 KiB)
    # 202.596 ms (372 allocations: 17.77 MiB)
    # 3.539 ms (102 allocations: 3.83 MiB)
    # 150.743 ms (371 allocations: 10.21 MiB)
    # 24.210 ms (101 allocations: 7.83 MiB)

    #disable_logging(Warn)
    #@btime Nucleus.MatrixFactorization.factorize($ma, $n_fa)
    #disable_logging(Debug)

    #@btime Nucleus.MatrixFactorization.solve_h($ma, $mw)

end

# ---- #

const MW = Nucleus.Simulation.make_matrix_1n(Float64, 3, 2)

# ---- #

const MH = Nucleus.Simulation.make_matrix_1n(Float64, 2, 3)

# ---- #

const DI = mkdir(joinpath(Nucleus.TE, "write"))

# ---- #

Nucleus.MatrixFactorization.write(DI, MW)

# ---- #

Nucleus.MatrixFactorization.write(DI, MH)

# ---- #

@test MW == Matrix(Nucleus.DataFrame.read(joinpath(DI, "2w.tsv"))[!, 2:end])

# ---- #

@test MH == Matrix(Nucleus.DataFrame.read(joinpath(DI, "2h.tsv"))[!, 2:end])

# ---- #

@test isfile(joinpath(DI, "2w.html"))

# ---- #

@test isfile(joinpath(DI, "2h.html"))

# ---- #

ma = rand(4, 8)

# ---- #

Nucleus.Plot.plot_heat_map("", ma; layout = Dict("title" => Dict("text" => "A")))

# ---- #

mw, mh = Nucleus.MatrixFactorization.factorize(ma, 3)

# ---- #

mwh = mw * mh

# ---- #

Nucleus.Plot.plot_heat_map("", mwh; layout = Dict("title" => Dict("text" => "W x H")))

# ---- #

# https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004760

# ---- #

ml = copy(mwh)

# ---- #

Nucleus.Normalization.normalize_with_logistic!(ml)

# ---- #

Nucleus.Plot.plot_heat_map("", ml; layout = Dict("title" => Dict("text" => "Logistic")))

# ---- #

prod(ml .^ ma .* (1 .- ml) .^ (1 .- ma))
