using Test: @test

using Nucleus

# ---- #

using Clustering: mutualinfo

using KernelDensity: kde

# ---- #

const NN = 10

# ---- #

const N1_ = randn(NN)

# ---- #

const N2_ = randn(NN)

# ---- #

# TODO: Test.
# TODO: Benchmark.
const NU___ = (ones(3), ones(3)),
([1, 2, 3], [10, 20, 30]),
(kde(N1_).density, kde(N2_).density),
(kde(N1_ .+ minimum(N1_)).density, kde(N2_ .+ minimum(N2_)).density)

# ---- #

for (n1_, n2_) in NU___

    for fu in (
        Nucleus.Information.get_kullback_leibler_divergence,
        Nucleus.Information.get_thermodynamic_depth,
        Nucleus.Information.get_thermodynamic_breadth,
    )

        Nucleus.Plot.plot_scatter(
            "",
            (n1_, n2_, fu.(n1_, n2_));
            name_ = (1, 2, "Result"),
            layout = Dict("title" => Dict("text" => string(fu))),
        )

    end

end

# ---- #

for (n1_, n2_) in NU___

    for fu in (
        Nucleus.Information.get_antisymmetric_kullback_leibler_divergence,
        Nucleus.Information.get_symmetric_kullback_leibler_divergence,
    )

        n3_ = (n1_ + n2_) / 2

        Nucleus.Plot.plot_scatter(
            "",
            (n1_, n2_, n3_, fu.(n1_, n2_, n3_));
            name_ = (1, 2, 3, "Result"),
            layout = Dict("title" => Dict("text" => string(fu))),
        )

    end

end

# ---- #

for (nu_, re) in (
    (zeros(10), 0.0),
    (ones(10), -0.0),
    (collect(1.0:10), -102.08283055193493),
    ([0.0, 2, 4, 8], -23.56700413903814),
)

    @test sum(Nucleus.Information.get_entropy, nu_) === re

    # 6.750 ns (0 allocations: 0 bytes)
    # 32.445 ns (0 allocations: 0 bytes)
    # 34.323 ns (0 allocations: 0 bytes)
    # 12.345 ns (0 allocations: 0 bytes)
    #@btime sum(Nucleus.Information.get_entropy, $nu_)

end

# ---- #

function get_entropy(nu)

    iszero(nu) ? 0.0 : -nu * log2(nu)

end

const JO = [
    1/8 1/16 1/16 1/4
    1/16 1/8 1/16 0
    1/32 1/32 1/16 0
    1/32 1/32 1/16 0
]

const P1_ = sum.(eachrow(JO))

@test P1_ == [1 / 2, 1 / 4, 1 / 8, 1 / 8]

const P2_ = sum.(eachcol(JO))

@test P2_ == [1 / 4, 1 / 4, 1 / 4, 1 / 4]

const E1 = sum(get_entropy, P1_)

@test E1 === 7 / 4

const E2 = sum(get_entropy, P2_)

@test E2 === 2.0

const EJ = sum(get_entropy, JO)

@test EJ === 27 / 8

const E12 = EJ - E2

@test E12 === sum(p2 * sum(get_entropy, co / p2) for (p2, co) in zip(P2_, eachcol(JO))) === 11 / 8

const E21 = EJ - E1

@test E21 === sum(p1 * sum(get_entropy, ro / p1) for (p1, ro) in zip(P1_, eachrow(JO))) === 13 / 8

const MU = E1 + E2 - EJ

@test MU === E1 - E12 === E2 - E21 === 3 / 8

# ---- #

# https://cdanielaam.medium.com/how-to-compare-and-evaluate-unsupervised-clustering-methods-84f3617e3769
for (jo, rf, rt) in (
    (
        [
            0.2 0 0 0 0
            0 0.2 0 0 0
            0.001 0 0.199 0 0
            0.002 0 0 0.198 0
            0.006 0.002 0 0 0.192
        ],
        1.5534700710552343,
        0.9653404496537963,
    ),
    (
        [
            0.2 0 0 0 0
            0.001 0 0.199 0 0
            0.006 0.002 0 0 0.192
            0.002 0 0 0.198 0
            0 0.2 0 0 0
        ],
        1.5534700710552343,
        0.9653404496537963,
    ),
)

    atol = 1e-15

    @test Nucleus.Information.get_mutual_information(jo) === rf

    @test isapprox(Nucleus.Information.get_mutual_information(jo, false), rf; atol)

    @test isapprox(Nucleus.Information.get_mutual_information(jo, true), rt; atol)

    # 161.485 ns (2 allocations: 192 bytes)
    # 116.631 ns (0 allocations: 0 bytes)
    # 116.630 ns (0 allocations: 0 bytes)
    # 162.606 ns (2 allocations: 192 bytes)
    # 116.676 ns (0 allocations: 0 bytes)
    # 116.676 ns (0 allocations: 0 bytes)

    #@btime Nucleus.Information.get_mutual_information($jo)

    #@btime Nucleus.Information.get_mutual_information($jo, false)

    #@btime Nucleus.Information.get_mutual_information($jo, true)

end

# ---- #

function is_nan_approximate(n1, n2, atol)

    n1 === n2 || isapprox(n1, n2; atol)

end

# ---- #

for nn in (2, 4, 8, 16, 32, 64)

    i1_ = rand(0:9, nn)

    i2_ = rand(0:9, nn)

    rf = mutualinfo(i1_, i2_; normed = false)

    rt = mutualinfo(i1_, i2_; normed = true)

    jo = Nucleus.Probability.get_joint(i1_, i2_)

    # 125.557 ns (2 allocations: 160 bytes)
    # 84.933 ns (0 allocations: 0 bytes)
    # 85.326 ns (0 allocations: 0 bytes)
    # 150.685 ns (2 allocations: 176 bytes)
    # 115.877 ns (0 allocations: 0 bytes)
    # 116.149 ns (0 allocations: 0 bytes)
    # 176.354 ns (2 allocations: 192 bytes)
    # 143.437 ns (0 allocations: 0 bytes)
    # 142.863 ns (0 allocations: 0 bytes)
    # 266.254 ns (2 allocations: 240 bytes)
    # 230.035 ns (0 allocations: 0 bytes)
    # 230.228 ns (0 allocations: 0 bytes)
    # 375.000 ns (2 allocations: 288 bytes)
    # 332.027 ns (0 allocations: 0 bytes)
    # 332.599 ns (0 allocations: 0 bytes)
    # 411.670 ns (2 allocations: 288 bytes)
    # 373.583 ns (0 allocations: 0 bytes)
    # 374.185 ns (0 allocations: 0 bytes)

    atol = 1e-14

    @test is_nan_approximate(Nucleus.Information.get_mutual_information(jo), rf, atol)

    #@btime Nucleus.Information.get_mutual_information($jo)

    for (no, re) in ((false, rf), (true, rt))

        @test is_nan_approximate(Nucleus.Information.get_mutual_information(jo, no), re, atol)

        #@btime Nucleus.Information.get_mutual_information($jo, $no)

    end

end

# ---- #

for (i1_, i2_, ri, rf) in (
    #
    ([1], [1], NaN, NaN),
    #
    ([1, 1], [1, 1], NaN, NaN),
    #
    ([1, 2], [1, 1], NaN, NaN),
    ([1, 2], [1, 2], 1.0, 1.0),
    ([1, 2], [1, 3], 1.0, 1.0),
    #
    ([1, 2, 3], [1, 1, 1], NaN, NaN),
    ([1, 2, 3], [1, 1, 2], 0.8485384755376776, 0.8448096756916619),
    ([1, 2, 3], [1, 1, 3], 0.8485384755376776, 0.8448096756916618),
    #
    ([1, 2, 3], [1, 2, 1], 0.0, 0.0),
    ([1, 2, 3], [1, 2, 2], 0.8485384755376776, 0.8448096756916624),
    ([1, 2, 3], [1, 2, 3], 1.0, 1.0),
    #
    ([1, 2, 3], [1, 3, 1], 0.0, 0.0),
    ([1, 2, 3], [1, 3, 2], 0.9428090415820634, 0.9356710796440404),
    ([1, 2, 3], [1, 3, 3], 0.8485384755376776, 0.8448096756916622),
    #
    ([1, 2, 1, 2], [1, 2, 1, 2], 1.0, 1.0),
    ([1, 2, 1, 2], [1, 3, 1, 3], 1.0, 1.0),
    #
    ([1, 2, 1, 2], [1, 2, 1, 3], 0.8660254037844386, 0.8619662349401314),
    ([1, 2, 1, 2], [1, 3, 1, 2], 0.8660254037844386, 0.8619662349401314),
    #
    ([1, 2, 1, 2], [2, 1, 2, 1], -1.0, -1.0),
    ([1, 2, 1, 2], [3, 1, 3, 1], -1.0, -1.0),
    #
    ([1, 2, 1, 2], [2, 1, 3, 1], -0.8660254037844386, -0.8619662349401319),
    ([1, 2, 1, 2], [3, 1, 2, 1], -0.8660254037844386, -0.8619662349401319),
)

    f1_ = convert(Vector{Float64}, i1_)

    f2_ = convert(Vector{Float64}, i2_)

    ii = Nucleus.Information.get_information_coefficient(i1_, i2_)

    il = Nucleus.Information.get_information_coefficient(f1_, f2_)

    atol = 0.05

    co = Nucleus.Information.cor(i1_, i2_)

    if !is_nan_approximate(co, ii, atol)

        @warn "$i1_ $i2_ $co $ii"

    end

    if !is_nan_approximate(co, il, atol)

        @warn "$i1_ $i2_ $co $il"

    end

    @test ii === ri

    @test il === rf

    # 23.469 ns (0 allocations: 0 bytes)
    # 22.860 ns (0 allocations: 0 bytes)
    # 24.892 ns (0 allocations: 0 bytes)
    # 23.343 ns (0 allocations: 0 bytes)
    # 24.934 ns (0 allocations: 0 bytes)
    # 23.762 ns (0 allocations: 0 bytes)
    # 24.933 ns (0 allocations: 0 bytes)
    # 23.803 ns (0 allocations: 0 bytes)
    # 24.849 ns (0 allocations: 0 bytes)
    # 23.761 ns (0 allocations: 0 bytes)
    # 24.623 ns (0 allocations: 0 bytes)
    # 25.016 ns (0 allocations: 0 bytes)
    # 827.135 ns (22 allocations: 2.34 KiB)
    # 26.583 μs (34 allocations: 52.33 KiB)
    # 829.342 ns (22 allocations: 2.34 KiB)
    # 26.417 μs (34 allocations: 52.33 KiB)
    # 831.597 ns (22 allocations: 2.34 KiB)
    # 27.000 μs (34 allocations: 52.33 KiB)
    # 831.597 ns (22 allocations: 2.34 KiB)
    # 26.375 μs (34 allocations: 52.33 KiB)
    # 26.256 ns (0 allocations: 0 bytes)
    # 25.016 ns (0 allocations: 0 bytes)
    # 825.236 ns (22 allocations: 2.34 KiB)
    # 27.083 μs (34 allocations: 52.33 KiB)
    # 860.368 ns (22 allocations: 2.38 KiB)
    # 27.458 μs (34 allocations: 52.33 KiB)
    # 830.479 ns (22 allocations: 2.34 KiB)
    # 26.334 μs (34 allocations: 52.33 KiB)
    # 21.692 ns (0 allocations: 0 bytes)
    # 25.309 ns (0 allocations: 0 bytes)
    # 27.470 ns (0 allocations: 0 bytes)
    # 25.058 ns (0 allocations: 0 bytes)
    # 857.143 ns (22 allocations: 2.34 KiB)
    # 25.833 μs (34 allocations: 52.36 KiB)
    # 859.717 ns (22 allocations: 2.34 KiB)
    # 25.834 μs (34 allocations: 52.36 KiB)
    # 23.659 ns (0 allocations: 0 bytes)
    # 25.058 ns (0 allocations: 0 bytes)
    # 27.470 ns (0 allocations: 0 bytes)
    # 25.310 ns (0 allocations: 0 bytes)
    # 866.340 ns (22 allocations: 2.34 KiB)
    # 25.958 μs (34 allocations: 52.36 KiB)
    # 860.864 ns (22 allocations: 2.34 KiB)
    # 26.041 μs (34 allocations: 52.36 KiB)

    #@btime Nucleus.Information.get_information_coefficient($i1_, $i2_)

    #@btime Nucleus.Information.get_information_coefficient($f1_, $f2_)

end
