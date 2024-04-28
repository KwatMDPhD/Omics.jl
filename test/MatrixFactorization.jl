using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

seed!(20240422)

const A1 = randn(10, 10)

const A2 = randn(10, 20)

const A3 = randn(20, 10)

const A4 = randn(20, 20)

# ---- #

A1 .-= minimum(A1)

A2 .-= minimum(A2)

A3 .-= minimum(A3)

A4 .-= minimum(A4)

# ---- #

for (A_, re) in (
    ((A1,), [1]),
    ((A1, A1), [0.5, 0.5]),
    ((A1, A1, A1), [1 / 3, 1 / 3, 1 / 3]),
    ((A1, A1 .* 2), [2 / 3, 1 / 3]),
)

    @test Nucleus.MatrixFactorization._get_coefficient(A_) == re

    # 116.067 ns (1 allocation: 64 bytes)
    # 225.506 ns (1 allocation: 80 bytes)
    # 335.396 ns (1 allocation: 80 bytes)
    # 226.812 ns (1 allocation: 80 bytes)
    #@btime Nucleus.MatrixFactorization._get_coefficient($A_)

end

# ---- #

function initialize(ar_...)

    seed!(20240427)

    Nucleus.MatrixFactorization._initialize(ar_...)

end

# ---- #

const to = 1e-4

const ma = 10^4

const UF = 3

# ---- #

for (id, A) in enumerate((A1, A2, A3, A4))

    W0 = initialize(A, UF)

    H0 = initialize(UF, A)

    W, H = Nucleus.MatrixFactorization.factorize(
        A,
        UF;
        init = :custom,
        W0,
        H0,
        alg = :multmse,
        tol = to,
        maxiter = ma,
    )

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "$(id)_w.html"), W)

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "$(id)_h.html"), H)

    @test all(>=(0), W)

    @test all(>=(0), H)

    AWi = Nucleus.MatrixFactorization.solve_h(W, A)

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "$(id)_awi.html"), AWi)

    @test all(>=(0), AWi)

    @test isapprox(H, AWi; rtol = 1e-3)

    #┌ Info: Converged with 914 iterations.
    #└   ob = 0.6741529947808842
    #  1.654 μs (20 allocations: 3.14 KiB)
    #  4.786 μs (91 allocations: 10.14 KiB)
    #┌ Info: Converged with 738 iterations.
    #└   ob = 1.4374956847624631
    #  2.421 μs (20 allocations: 4.73 KiB)
    #j  9.416 μs (181 allocations: 20.22 KiB)
    #┌ Info: Converged with 934 iterations.
    #└   ob = 1.3383717598237397
    #  2.144 μs (20 allocations: 4.73 KiB)
    #  6.158 μs (91 allocations: 14.05 KiB)
    #┌ Info: Converged with 1746 iterations.
    #└   ob = 1.7146732148845611
    #  3.302 μs (20 allocations: 7.05 KiB)
    #  12.125 μs (181 allocations: 28.03 KiB)

    #disable_logging(Warn)
    #@btime Nucleus.MatrixFactorization.factorize(
    #    $A,
    #    UF;
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

    A_ = (A, A)

    W0 = initialize(A, UF)

    H0_ = [initialize(UF, A) for _ in eachindex(A_)]

    W, H_ = Nucleus.MatrixFactorization.factorize_wide(A_, UF; W = W0, H_ = H0_, to, ma)

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "si_$(id)_w.html"), W)

    for ia in eachindex(A_)

        Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "si_$(id)_h$ia.html"), H_[ia])

    end

    @test all(>=(0), W)

    for ia in eachindex(A_)

        @test all(>=(0), H_[ia])

    end

    #┌ Info: Converged with 402 iterations.
    #│   ob =
    #│    2-element Vector{Float64}:
    #│     0.6743289169156936
    #└     0.6743289169156936
    #  1.850 μs (16 allocations: 3.22 KiB)
    #┌ Info: Converged with 459 iterations.
    #│   ob =
    #│    2-element Vector{Float64}:
    #│     1.4377058426055105
    #└     1.4377058426055105
    #  2.801 μs (16 allocations: 4.81 KiB)
    #┌ Info: Converged with 234 iterations.
    #│   ob =
    #│    2-element Vector{Float64}:
    #│     1.3385646237203688
    #└     1.3385646237203688
    #  2.532 μs (16 allocations: 4.81 KiB)
    #┌ Info: Converged with 637 iterations.
    #│   ob =
    #│    2-element Vector{Float64}:
    #│     1.7150104469069736
    #└     1.7150104469069736
    #  4.036 μs (16 allocations: 7.12 KiB)

    #disable_logging(Warn)
    #@btime Nucleus.MatrixFactorization.factorize_wide($(A,), UF; W = $W0, H_ = $(H0_[1],), to, ma)
    #disable_logging(Debug)

end

# ---- #

seed!(20240427)

A_ = (rand(20, 40), rand(20, 40), rand(20, 40))

co_ = [1, 1, 1]

W, H_ = Nucleus.MatrixFactorization.factorize_wide(A_, 4; co_ = co_ ./ sum(co_))

Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "te_w.html"), W)

for ia in eachindex(A_)

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "te_h$ia.html"), H_[ia])

end

for ia in eachindex(A_)

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "te_a$ia.html"), A_[ia])

    Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "te_wh$ia.html"), W * H_[ia])

end
