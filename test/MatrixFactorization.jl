using Random: seed!

using StatsBase: mean

using Test: @test

using Omics

# ---- #

seed!(20240422)

const A1 = map(nu -> nu + 4.0, randn(10, 10))

const A2 = map(nu -> nu + 4.0, randn(10, 20))

const A3 = map(nu -> nu + 4.0, randn(20, 10))

const A4 = map(nu -> nu + 4.0, randn(20, 20))

# ---- #

# 111.622 ns (2 allocations: 64 bytes)
# 213.287 ns (2 allocations: 80 bytes)
# 213.287 ns (2 allocations: 80 bytes)

for (A_, re) in (((A1,), [1.0]), ((A1, A1), [1.0, 1.0]), ((A1, A1 * 2), [1, 0.5]))

    @test Omics.MatrixFactorization._get_coefficient(A_) == re

    #@btime Omics.MatrixFactorization._get_coefficient($A_)

end

# ---- #

function initialize(ar_...)

    seed!(20240427)

    Omics.MatrixFactorization._initialize(ar_...)

end

# ---- #

for A in (A1, A2, A3, A4), fa in (1, 2, 4), nu in (2, 4, 8)

    WH = initialize(A, nu) * initialize(nu, A)

    @test isapprox(mean(A), mean(WH))

    @info "$nu $(Omics.MatrixFactorization._get_objective(A, WH))"

end

# ---- #

const to = 1e-4

const NU = 3

const n2 = 1000

# ---- #

#┌ Info: Converged in 481.
#└   ob = 0.20499998731688607
#  1.196 μs (15 allocations: 2.86 KiB)
#  3.672 μs (152 allocations: 10.31 KiB)
#┌ Info: Converged in 425.
#└   ob = 0.3142612867299134
#  1.817 μs (15 allocations: 4.38 KiB)
#  7.281 μs (302 allocations: 20.58 KiB)
#┌ Info: Converged in 281.
#└   ob = 0.22492657317328926
#  1.542 μs (15 allocations: 4.38 KiB)
#  5.132 μs (152 allocations: 14.53 KiB)
#┌ Info: Converged in 804.
#└   ob = 0.29934276449451963
#  2.435 μs (16 allocations: 6.73 KiB)
#  10.083 μs (302 allocations: 29.02 KiB)

for (id, A) in enumerate((A1, A2, A3, A4))

    W0 = initialize(A, NU)

    H0 = initialize(NU, A)

    W, H = Omics.MatrixFactorization.factorize(
        A,
        NU;
        init = :custom,
        W0,
        H0,
        alg = :multmse,
        tol = to,
        maxiter = n2,
    )

    Omics.Plot.plot_heat_map(joinpath(tempdir(), "$id.w.html"), W)

    Omics.Plot.plot_heat_map(joinpath(tempdir(), "$id.h.html"), H)

    @test all(>=(0.0), W)

    @test all(>=(0.0), H)

    AWi = Omics.MatrixFactorization.solve_h(W, A)

    Omics.Plot.plot_heat_map(joinpath(tempdir(), "$id.awi.html"), AWi)

    @test all(>=(0.0), AWi)

    @test isapprox(H, AWi; rtol = 1e-2)

    #disable_logging(Warn)
    #@btime Omics.MatrixFactorization.factorize(
    #    $A,
    #    NU;
    #    init = :custom,
    #    W0 = $W0,
    #    H0 = $H0,
    #    alg = :multmse,
    #    tol = to,
    #    maxiter = n2,
    #)
    #disable_logging(Debug)

    #@btime Omics.MatrixFactorization.solve_h($W, $A)

end

# ---- #

#┌ Info: Converged in 471.
#│   ob =
#│    2-element Vector{Float64}:
#│     0.2050057657196614
#└     0.2050057657196614
#  1.708 μs (32 allocations: 3.36 KiB)
#┌ Info: Converged in 502.
#│   ob =
#│    2-element Vector{Float64}:
#│     0.3142841434306548
#└     0.3142841434306548
#  2.546 μs (32 allocations: 4.88 KiB)
#┌ Info: Converged in 348.
#│   ob =
#│    2-element Vector{Float64}:
#│     0.2249289266965805
#└     0.2249289266965805
#  2.306 μs (32 allocations: 4.88 KiB)
#┌ Info: Converged in 648.
#│   ob =
#│    2-element Vector{Float64}:
#│     0.2993410572495553
#└     0.2993410572495553
#  3.620 μs (33 allocations: 7.23 KiB)

for (i1, A) in enumerate((A1, A2, A3, A4))

    A_ = [A, A]

    W0 = initialize(A, NU)

    H0_ = map(A -> initialize(NU, A), A_)

    W, H_ = Omics.MatrixFactorization.factorize_wide(A_, NU; W = W0, H_ = H0_, n2, to)

    @test all(>=(0.0), W)

    Omics.Plot.plot_heat_map(joinpath(tempdir(), "wide.$i1.w.html"), W)

    for i2 in eachindex(A_)

        H = H_[i2]

        @test all(>=(0.0), H)

        Omics.Plot.plot_heat_map(joinpath(tempdir(), "wide.$i1.h.$i2.html"), H)

    end

    #disable_logging(Warn)
    #@btime Omics.MatrixFactorization.factorize_wide(
    #    $[A],
    #    NU;
    #    W = $W0,
    #    H_ = $[H0_[1]],
    #    n2,
    #    to,
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
