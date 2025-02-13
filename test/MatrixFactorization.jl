using Random: seed!

using Test: @test

using Omics

# ---- #

seed!(20240422)

const A1 = randn(10, 10)

const A2 = randn(10, 20)

const A3 = randn(20, 10)

const A4 = randn(20, 20)

A1 .-= minimum(A1)

A2 .-= minimum(A2)

A3 .-= minimum(A3)

A4 .-= minimum(A4)

# ---- #

# 110.931 ns (2 allocations: 64 bytes)
# 211.652 ns (2 allocations: 80 bytes)
# 308.845 ns (2 allocations: 80 bytes)
# 211.650 ns (2 allocations: 80 bytes)

for (A_, re) in
    (((A1,), [1]), ((A1, A1), [1, 1]), ((A1, A1, A1), [1, 1, 1]), ((A1, A1 .* 2), [1, 0.5]))

    @test Omics.MatrixFactorization._get_coefficient(A_) == re

    @btime Omics.MatrixFactorization._get_coefficient($A_)

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

#┌ Info: Converged in 407.
#└   ob = 0.20339394658990206
#  1.254 μs (15 allocations: 2.86 KiB)
#  4.089 μs (152 allocations: 10.31 KiB)
#┌ Info: Converged in 375.
#└   ob = 0.314316132822924
#  1.871 μs (15 allocations: 4.38 KiB)
#  8.083 μs (302 allocations: 20.58 KiB)
#┌ Info: Converged in 223.
#└   ob = 0.22517583992451562
#  1.604 μs (15 allocations: 4.38 KiB)
#  5.528 μs (152 allocations: 14.53 KiB)
#┌ Info: Converged in 781.
#└   ob = 0.2992436074427608
#  2.481 μs (16 allocations: 6.73 KiB)
#  10.875 μs (302 allocations: 29.02 KiB)

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

    disable_logging(Warn)
    @btime Omics.MatrixFactorization.factorize(
        $A,
        UF;
        init = :custom,
        W0 = $W0,
        H0 = $H0,
        alg = :multmse,
        tol = to,
        maxiter = ma,
    )
    disable_logging(Debug)

    @btime Omics.MatrixFactorization.solve_h($W, $A)

end

# ---- #

#┌ Info: Converged in 402.
#│   ob =
#│    2-element Vector{Float64}:
#│     0.20339105382690983
#└     0.20339105382690983
#  1.617 μs (32 allocations: 3.36 KiB)
#┌ Info: Converged in 459.
#│   ob =
#│    2-element Vector{Float64}:
#│     0.3143278250697895
#└     0.3143278250697895
#  2.458 μs (32 allocations: 4.88 KiB)
#┌ Info: Converged in 234.
#│   ob =
#│    2-element Vector{Float64}:
#│     0.22517603717590295
#└     0.22517603717590295
#  2.167 μs (32 allocations: 4.88 KiB)
#┌ Info: Converged in 637.
#│   ob =
#│    2-element Vector{Float64}:
#│     0.29924253061077155
#└     0.29924253061077155
#  3.464 μs (33 allocations: 7.23 KiB)

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

    disable_logging(Warn)
    @btime Omics.MatrixFactorization.factorize_wide(
        $(A,),
        UF;
        W = $W0,
        H_ = $(H0_[1],),
        to,
        ma,
    )
    disable_logging(Debug)

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
