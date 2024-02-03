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

        n3_ = 0.5 * (n1_ + n2_)

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
    (1:10, -102.08283055193493),
    ([0, 2, 4, 8], -23.56700413903814),
)

    @test sum(Nucleus.Information.get_entropy, nu_) === re

    # 6.750 ns (0 allocations: 0 bytes)
    # 32.445 ns (0 allocations: 0 bytes)
    # 34.954 ns (0 allocations: 0 bytes)
    # 12.554 ns (0 allocations: 0 bytes)
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
for (jo, (rf, rt)) in (
    (
        [
            0.2 0 0 0 0
            0 0.2 0 0 0
            0.001 0 0.199 0 0
            0.002 0 0 0.198 0
            0.006 0.002 0 0 0.192
        ],
        (1.5534700710552343, 0.9653404496537963),
    ),
    (
        [
            0.2 0 0 0 0
            0.001 0 0.199 0 0
            0.006 0.002 0 0 0.192
            0.002 0 0 0.198 0
            0 0.2 0 0 0
        ],
        (1.5534700710552343, 0.9653404496537963),
    ),
)

    atol = 1e-15

    # 161.485 ns (2 allocations: 192 bytes)
    # 116.631 ns (0 allocations: 0 bytes)
    # 116.630 ns (0 allocations: 0 bytes)
    # 162.606 ns (2 allocations: 192 bytes)
    # 116.676 ns (0 allocations: 0 bytes)
    # 116.676 ns (0 allocations: 0 bytes)

    @test Nucleus.Information.get_mutual_information(jo) === rf

    #@btime Nucleus.Information.get_mutual_information($jo)

    for (no, re) in ((false, rf), (true, rt))

        @test isapprox(Nucleus.Information.get_mutual_information(jo, no), re; atol)

        #@btime Nucleus.Information.get_mutual_information($jo, $no)

    end

end

# ---- #

const TE_ = ((1:10, 1:10), (1:10, 10:-1:1), (1:10, 1:10:100))

# ---- #

for (n1_, n2_) in TE_

    i1_ = convert(Vector{Int}, n2_)

    i2_ = convert(Vector{Int}, n1_)

    rf = mutualinfo(i1_, i2_; normed = false)

    rt = mutualinfo(i1_, i2_; normed = true)

    jo = Nucleus.Probability.get_joint(i1_, i2_)

    atol = 1e-15

    # 266.230 ns (2 allocations: 288 bytes)
    # 258.120 ns (0 allocations: 0 bytes)
    # 258.549 ns (0 allocations: 0 bytes)
    # 265.721 ns (2 allocations: 288 bytes)
    # 258.238 ns (0 allocations: 0 bytes)
    # 258.713 ns (0 allocations: 0 bytes)
    # 265.592 ns (2 allocations: 288 bytes)
    # 258.358 ns (0 allocations: 0 bytes)
    # 258.358 ns (0 allocations: 0 bytes)

    @test isapprox(Nucleus.Information.get_mutual_information(jo), rf; atol)

    #@btime Nucleus.Information.get_mutual_information($jo)

    for (no, re) in ((false, rf), (true, rt))

        @test isapprox(Nucleus.Information.get_mutual_information(jo, no), re; atol)

        #@btime Nucleus.Information.get_mutual_information($jo, $no)

    end

end

# ---- #

for (n1_, n2_) in (([0, 0, 0, 0.1], [3.0, 3.0, 3.0, 3.1]),)

    for fu in (Nucleus.Information.cor, Nucleus.Information.get_information_coefficient)

        @info fu(n1_, n2_)

        # 10.052 ns (0 allocations: 0 bytes)
        # 250.441 ns (12 allocations: 1.06 KiB)
        #@btime $fu($n1_, $n2_)

    end

end

# ---- #

for ((n1_, n2_), re_) in zip(
    TE_,
    (
        (0.99498743710662, 0.9938079899999066),
        (-0.99498743710662, -0.9921567416492216),
        (0.99498743710662, 0.9938079899999067),
    ),
)

    for (ty, re) in zip((Int, Float64), re_)

        n1_ = convert(Vector{ty}, n1_)

        n2_ = convert(Vector{ty}, n2_)

        @test Nucleus.Information.get_information_coefficient(n1_, n2_) === re

        # 1.308 μs (24 allocations: 4.53 KiB)
        # 25.750 μs (48 allocations: 54.17 KiB)
        # 1.312 μs (24 allocations: 4.53 KiB)
        # 25.708 μs (48 allocations: 54.17 KiB)
        # 1.337 μs (24 allocations: 4.53 KiB)
        # 25.583 μs (48 allocations: 54.17 KiB)
        #@btime Nucleus.Information.get_information_coefficient($n1_, $n2_)

    end

end

# ---- #

for (n1_, n2_, re) in (
    # allequal
    ([1], [2], NaN),
    ([1, 1], [2, 2], NaN),
    ([1, 1], [1, 2], NaN),
    ([1, 1, 1], [2, 2, 2], NaN),
    ([1, 1, 1], [1, 1, 2], NaN),
    ([1, 1, 1], [1, 2, 3], NaN),
    # ==
    ([1, 2], [1, 2], 0.8660254037844386),
    ([1, 2], [1, 2.0], 1.0),
    ([1, 2], [1, 2 + eps()], 1.0),
    # Integer
    ([1, 2], [1, 3], 0.8660254037844386),
    ([1, 2], [1, 4], 0.8660254037844386),
    # Integer vs AbstractFloat
    ([1, 2, 3], [1, 2, 4], 0.9428090415820634),
    ([1.0, 2, 3], [1, 2, 4], 0.9383956314224317),
    # ~
    ([1, 2], [1, 2.001], 1.0),
    ([1, 2, 3], [1, 2, 3.001], 0.9428090415817324),
    ([1, 2, 3, 4], [1, 2, 3, 4.001], 0.9682458365517885),
)

    @test Nucleus.Information.get_information_coefficient(n1_, n2_) === re

    # 661.892 ns (22 allocations: 2.25 KiB)
    # 692.125 ns (22 allocations: 2.25 KiB)
    # 754.386 ns (22 allocations: 2.28 KiB)
    # 715.022 ns (22 allocations: 2.25 KiB)
    # 770.837 ns (22 allocations: 2.28 KiB)
    # 807.835 ns (22 allocations: 2.28 KiB)
    # 765.625 ns (22 allocations: 2.31 KiB)
    # 299.284 ns (12 allocations: 1.06 KiB)
    # 298.792 ns (12 allocations: 1.06 KiB)
    # 770.836 ns (22 allocations: 2.31 KiB)
    # 766.291 ns (22 allocations: 2.31 KiB)
    # 871.075 ns (22 allocations: 2.38 KiB)
    # 25.958 μs (46 allocations: 53.39 KiB)
    # 299.447 ns (12 allocations: 1.06 KiB)
    # 25.375 μs (46 allocations: 53.39 KiB)
    # 25.667 μs (46 allocations: 53.42 KiB)
    #@btime Nucleus.Information.get_information_coefficient($n1_, $n2_)

end
