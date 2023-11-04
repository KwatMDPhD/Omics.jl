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

    di = mkdir(joinpath(Nucleus.TE, "$(n_ro)_$(n_co)_$(n_fa)"))

    Nucleus.MatrixFactorization.write(di, mw)

    Nucleus.MatrixFactorization.write(di, mh)

    mh2 = Nucleus.MatrixFactorization.solve_h(ma, mw)

    @test isapprox(mh, mh2; rtol = 1)

    Nucleus.MatrixFactorization.write(mkdir("$(di)_solved"), mh2; naf = "Solved")

    # 9.417 μs (58 allocations: 6.95 KiB)
    # 2.116 μs (23 allocations: 2.78 KiB)
    # 224.333 μs (128 allocations: 40.97 KiB)
    # 3.151 μs (23 allocations: 4.33 KiB)
    # 2.888 s (4331 allocations: 221.99 MiB)
    # 144.417 μs (24 allocations: 172.08 KiB)
    # 7.915 s (12949 allocations: 363.06 MiB)
    # 288.292 μs (27 allocations: 329.34 KiB)

    #@btime Nucleus.MatrixFactorization.factorize($ma, $n_fa)

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

@test MW == Matrix(Nucleus.DataFrame.read(joinpath(DI, "w.tsv"))[!, 2:end])

# ---- #

@test MH == Matrix(Nucleus.DataFrame.read(joinpath(DI, "h.tsv"))[!, 2:end])

# ---- #

@test isfile(joinpath(DI, "w.html"))

# ---- #

@test isfile(joinpath(DI, "h.html"))

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
