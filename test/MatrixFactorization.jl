using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

seed!(2023092820240422)

const A1 = randn(8, 8)

const A2 = randn(8, 16)

const A3 = randn(16, 16)

const A4 = randn(16, 32)

A1 .-= minimum(A1)

A2 .-= minimum(A2)

A3 .-= minimum(A3)

A4 .-= minimum(A4)

# ---- #

const to = 1e-3

const ui = 10^1

const uf = 3

# ---- #

for (id, A) in enumerate((A1,))

    W, H = Nucleus.MatrixFactorization.factorize(
        A,
        uf;
        init = :random,
        alg = :multmse,
        tol = to,
        maxiter = ui,
        verbose = true,
    )

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "$(id)w.html"), W)

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "$(id)h.html"), H)

    @test size(W) === (size(A, 1), uf)

    @test size(H) === (uf, size(A, 2))

    @test all(>=(0), W)

    @test all(>=(0), H)

    AWi = Nucleus.MatrixFactorization.solve_h(W, A)

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "$(id)awi.html"), AWi)

    @test size(AWi) === size(H)

    @test all(>=(0), AWi)

    @test isapprox(H, AWi; rtol = 1e-1)

    #┌ Info: Converged with 223 iterations.
    #└   re.objvalue = 7.267759831700613
    #  80.875 μs (18 allocations: 2.94 KiB)
    #  2.199 μs (28 allocations: 4.47 KiB)
    #┌ Warning: Failed to converged with 1000 iterations.
    #│   re.objvalue = 24.020152551969993
    #└ @ Nucleus.MatrixFactorization ~/craft/jl/Nucleus.jl/src/MatrixFactorization.jl:23
    #  166.083 μs (18 allocations: 4.19 KiB)
    #  4.000 μs (28 allocations: 6.91 KiB)
    #┌ Info: Converged with 524 iterations.
    #└   re.objvalue = 69.00092272342778
    #  281.625 μs (18 allocations: 6.12 KiB)
    #  4.732 μs (28 allocations: 10.84 KiB)
    #┌ Warning: Failed to converged with 1000 iterations.
    #│   re.objvalue = 161.3491056540221
    #└ @ Nucleus.MatrixFactorization ~/craft/jl/Nucleus.jl/src/MatrixFactorization.jl:23
    #  705.750 μs (18 allocations: 9.88 KiB)
    #  10.875 μs (28 allocations: 18.97 KiB)

    #disable_logging(Warn)
    #@btime Nucleus.MatrixFactorization.factorize(
    #    $A,
    #    uf;
    #    init = :random,
    #    alg = :multmse,
    #    tol = to,
    #    maxiter = ui,
    #)
    #disable_logging(Debug)

    #@btime Nucleus.MatrixFactorization.solve_h($A, $W)

end

# ---- #

for (id, A) in enumerate((A1,))

    A_ = (A, A)

    W, H_ = Nucleus.MatrixFactorization.factorize_wide(A_, uf; to, ui)

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "$(id)sw.html"), W)

    for (ih, H) in enumerate(H_)

        Nucleus.Plot.plot_heat_map(
            joinpath(Nucleus.TE, "$(id)sh$ih.html"),
            H;
            layout = Dict("title" => Dict("text" => ih)),
        )

    end

    @test size(W) === (size(A_[1], 1), uf)

    @test all(>=(0), W)

    for ia in 1:lastindex(A_)

        H = H_[ia]

        @test size(H) === (uf, size(A_[ia], 2))

        @test all(>=(0), H)

    end

    #┌ Warning: Failed to converged with 1000 iterations.
    #│   ob_ =
    #│    1-element Vector{Float64}:
    #│     1742.9433128938886
    #└ @ Nucleus.MatrixFactorization ~/craft/jl/Nucleus.jl/src/MatrixFactorization.jl:155
    #  579.292 μs (16 allocations: 2.62 KiB)
    #┌ Warning: Failed to converged with 1000 iterations.
    #│   ob_ =
    #│    1-element Vector{Float64}:
    #│     1502.51233919367
    #└ @ Nucleus.MatrixFactorization ~/craft/jl/Nucleus.jl/src/MatrixFactorization.jl:155
    #^[  834.125 μs (16 allocations: 3.69 KiB)
    #┌ Warning: Failed to converged with 1000 iterations.
    #│   ob_ =
    #│    1-element Vector{Float64}:
    #│     7267.39999602119
    #└ @ Nucleus.MatrixFactorization ~/craft/jl/Nucleus.jl/src/MatrixFactorization.jl:155
    #  1.130 ms (16 allocations: 5.44 KiB)
    #┌ Warning: Failed to converged with 1000 iterations.
    #│   ob_ =
    #│    1-element Vector{Float64}:
    #│     9405.538943969412
    #└ @ Nucleus.MatrixFactorization ~/craft/jl/Nucleus.jl/src/MatrixFactorization.jl:155
    #  1.969 ms (16 allocations: 8.75 KiB)

    #disable_logging(Warn)
    #@btime Nucleus.MatrixFactorization.factorize_wide($A_, uf; to, ui)
    #disable_logging(Debug)

end
