using Random: seed!

using Test: @test

using Omics

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

# 115.251 ns (1 allocation: 64 bytes)
# 219.285 ns (1 allocation: 80 bytes)
# 316.911 ns (1 allocation: 80 bytes)
# 219.368 ns (1 allocation: 80 bytes)

for (A_, re) in
    (((A1,), [1]), ((A1, A1), [1, 1]), ((A1, A1, A1), [1, 1, 1]), ((A1, A1 .* 2), [1, 0.5]))

    @test Omics.MatrixFactorization._get_coefficient(A_) == re

    #@btime Omics.MatrixFactorization._get_coefficient($A_)

end

# ---- #

function initialize(ar_...)

    seed!(20240427)

    Omics.MatrixFactorization._initialize(ar_...)

end

# ---- #

const to = 1e-4

const ma = 10^4

const UF = 3

# ---- #

#┌ Info: Converged with 914 iterations.
#└   ob = 0.6741529947808842
#  1.871 μs (20 allocations: 3.14 KiB)
#  4.979 μs (91 allocations: 10.14 KiB)
#┌ Info: Converged with 738 iterations.
#└   ob = 1.4374956847624631
#  2.597 μs (20 allocations: 4.73 KiB)
#  9.834 μs (181 allocations: 20.22 KiB)
#┌ Info: Converged with 934 iterations.
#└   ob = 1.3383717598237397
#  2.352 μs (20 allocations: 4.73 KiB)
#  6.375 μs (91 allocations: 14.05 KiB)
#┌ Info: Converged with 1746 iterations.
#└   ob = 1.7146732148845611
#  3.474 μs (20 allocations: 7.05 KiB)
#  12.625 μs (181 allocations: 28.03 KiB)

for (id, A) in enumerate((A1, A2, A3, A4))

    W0 = initialize(A, UF)

    H0 = initialize(UF, A)

    W, H = Omics.MatrixFactorization.factorize(
        A,
        UF;
        init = :custom,
        W0,
        H0,
        alg = :multmse,
        tol = to,
        maxiter = ma,
    )

    Omics.Plot.plot_heat_map(joinpath(tempdir(), "$(id)_w.html"), W)

    Omics.Plot.plot_heat_map(joinpath(tempdir(), "$(id)_h.html"), H)

    @test all(>=(0), W)

    @test all(>=(0), H)

    AWi = Omics.MatrixFactorization.solve_h(W, A)

    Omics.Plot.plot_heat_map(joinpath(tempdir(), "$(id)_awi.html"), AWi)

    @test all(>=(0), AWi)

    @test isapprox(H, AWi; rtol = 1e-2)

    #disable_logging(Warn)
    #@btime Omics.MatrixFactorization.factorize(
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

    #@btime Omics.MatrixFactorization.solve_h($W, $A)

end

# ---- #

#┌ Info: Converged with 402 iterations.
#│   ob =
#│    2-element Vector{Float64}:
#│     0.6743289169372342
#└     0.6743289169372342
#  1.775 μs (16 allocations: 3.22 KiB)
#┌ Info: Converged with 459 iterations.
#│   ob =
#│    2-element Vector{Float64}:
#│     1.4377058427756195
#└     1.4377058427756195
#  2.731 μs (16 allocations: 4.81 KiB)
#┌ Info: Converged with 234 iterations.
#│   ob =
#│    2-element Vector{Float64}:
#│     1.3385646237237367
#└     1.3385646237237367
#  2.444 μs (16 allocations: 4.81 KiB)
#┌ Info: Converged with 637 iterations.
#│   ob =
#│    2-element Vector{Float64}:
#│     1.7150104467124012
#└     1.7150104467124012
#  3.970 μs (16 allocations: 7.12 KiB)

for (id, A) in enumerate((A1, A2, A3, A4))

    A_ = (A, A)

    W0 = initialize(A, UF)

    H0_ = [initialize(UF, A) for _ in eachindex(A_)]

    W, H_ = Omics.MatrixFactorization.factorize_wide(A_, UF; W = W0, H_ = H0_, to, ma)

    Omics.Plot.plot_heat_map(joinpath(tempdir(), "si_$(id)_w.html"), W)

    for ia in eachindex(A_)

        Omics.Plot.plot_heat_map(joinpath(tempdir(), "si_$(id)_h$ia.html"), H_[ia])

    end

    @test all(>=(0), W)

    for ia in eachindex(A_)

        @test all(>=(0), H_[ia])

    end

    #disable_logging(Warn)
    #@btime Omics.MatrixFactorization.factorize_wide(
    #    $(A,),
    #    UF;
    #    W = $W0,
    #    H_ = $(H0_[1],),
    #    to,
    #    ma,
    #)
    #disable_logging(Debug)

end

# ---- #

seed!(20240427)

A_ = (rand(20, 40), rand(20, 40), rand(20, 40))

W, H_ = Omics.MatrixFactorization.factorize_wide(A_, 4; co_ = [2, 2, 2])

Omics.Plot.plot_heat_map(joinpath(tempdir(), "te_w.html"), W)

for ia in eachindex(A_)

    Omics.Plot.plot_heat_map(joinpath(tempdir(), "te_h$ia.html"), H_[ia])

end

# ---- #

for ia in eachindex(A_)

    Omics.Plot.plot_heat_map(joinpath(tempdir(), "te_a$ia.html"), A_[ia])

    Omics.Plot.plot_heat_map(joinpath(tempdir(), "te_wh$ia.html"), W * H_[ia])

end
