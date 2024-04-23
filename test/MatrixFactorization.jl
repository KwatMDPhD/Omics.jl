using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

seed!(20240422)

const A1 = randn(8, 8)

const A2 = randn(8, 16)

const A3 = randn(16, 16)

const A4 = randn(16, 32)

A1 .-= minimum(A1)

A2 .-= minimum(A2)

A3 .-= minimum(A3)

A4 .-= minimum(A4)

# ---- #

const to = 1e-4

const ma = 10^4

const uf = 3

# ---- #

for (id, A) in enumerate((A1, A2, A3, A4))

    seed!(20240422)

    W0 = Nucleus.MatrixFactorization._initialize(A, uf)

    H0 = Nucleus.MatrixFactorization._initialize(uf, A)

    W, H = Nucleus.MatrixFactorization.factorize(
        A,
        uf;
        init = :custom,
        W0,
        H0,
        alg = :multmse,
        tol = to,
        maxiter = ma,
    )

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "$(id)w.html"), W)

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "$(id)h.html"), H)

    @test all(>=(0), W)

    @test all(>=(0), H)

    AWi = Nucleus.MatrixFactorization.solve_h(W, A)

    Nucleus.Plot.plot_heat_map(
        joinpath(Nucleus.TE, "$(id)awi.html"),
        AWi;
        layout = Dict("title" => Dict("text" => "AWi")),
    )

    @test all(>=(0), AWi)

    @test isapprox(H, AWi; rtol = 1e-3)

    #┌ Info: Converged with 900 iterations.
    #└   ob = 8.357147435525784
    #  1.250 μs (18 allocations: 2.52 KiB)
    #  3.276 μs (73 allocations: 7.50 KiB)
    #┌ Info: Converged with 496 iterations.
    #└   ob = 20.901416313405537
    #  1.658 μs (18 allocations: 3.58 KiB)
    #  6.525 μs (145 allocations: 14.94 KiB)
    #┌ Info: Converged with 1394 iterations.
    #└   ob = 57.35550497172282
    #  2.065 μs (18 allocations: 5.33 KiB)
    #  8.195 μs (145 allocations: 19.94 KiB)
    #┌ Info: Converged with 1933 iterations.
    #└   ob = 155.4344525901171
    #  3.260 μs (18 allocations: 8.64 KiB)
    #  16.250 μs (289 allocations: 39.88 KiB)

    #disable_logging(Warn)
    #@btime Nucleus.MatrixFactorization.factorize(
    #    $A,
    #    uf;
    #    init = :custom,
    #    W0 = $W0,
    #    H0 = $H0,
    #    alg = :multmse,
    #    tol = to,
    #    maxiter = ma,
    #)
    #disable_logging(Debug)

    #@btime Nucleus.MatrixFactorization.solve_h($W, $A)

end

# ---- #

for (id, A) in enumerate((A1, A2, A3, A4))

    seed!(20240422)

    A_ = (A, A)

    W0 = Nucleus.MatrixFactorization._initialize(A, uf)

    H0 = Nucleus.MatrixFactorization._initialize(uf, A)

    H0_ = [copy(H0) for _ in A_]

    W, H_ = Nucleus.MatrixFactorization.factorize_wide(A_, uf; W = W0, H_ = H0_, to, ma)

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "$(id)sw.html"), W)

    for (ih, H) in enumerate(H_)

        Nucleus.Plot.plot_heat_map(
            joinpath(Nucleus.TE, "$(id)sh$ih.html"),
            H;
            layout = Dict("title" => Dict("text" => ih)),
        )

    end

    @test all(>=(0), W)

    for ia in eachindex(A_)

        @test all(>=(0), H_[ia])

    end

    #┌ Info: Converged with 195 iterations.
    #│   ob =
    #│    2-element Vector{Float64}:
    #│     8.361346897830222
    #└     8.361346897830222
    #  1.242 μs (15 allocations: 2.56 KiB)
    #┌ Info: Converged with 112 iterations.
    #│   ob =
    #│    2-element Vector{Float64}:
    #│     20.90411783954717
    #└     20.90411783954717
    #  1.792 μs (15 allocations: 3.62 KiB)
    #┌ Info: Converged with 405 iterations.
    #│   ob =
    #│    2-element Vector{Float64}:
    #│     57.37454392418523
    #└     57.37454392418523
    #  2.435 μs (15 allocations: 5.38 KiB)
    #┌ Info: Converged with 676 iterations.
    #│   ob =
    #│    2-element Vector{Float64}:
    #│     155.48641480203864
    #└     155.48641480203864
    #  4.184 μs (15 allocations: 8.69 KiB)

    #disable_logging(Warn)
    #@btime Nucleus.MatrixFactorization.factorize_wide($(A,), uf; W = $W0, H_ = $(H0,), to, ma)
    #disable_logging(Debug)

end
