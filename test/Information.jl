using Information

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Clustering: mutualinfo

using Distances: CorrDist, Euclidean, pairwise

using KernelDensity: kde

using Random: seed!

using Plot

using Probability

# ---- #

for (pr_, re) in (
    ([0], 0.0),
    ([0, 0], 0.0),
    ([1], -0.0),
    ([1, 1], -0.0),
    ([0.001, 0.999], 0.007907255112232087),
    ([0.01, 0.99], 0.056001534354847345),
    ([0.1, 0.9], 0.3250829733914482),
    ([0.2, 0.8], 0.5004024235381879),
    ([0.3, 0.7], 0.6108643020548935),
    ([0.4, 0.6], 0.6730116670092565),
    ([0.5, 0.5], 0.6931471805599453),
    ([1 / 3, 1 / 3, 1 / 3], 1.0986122886681096),
    ([0.25, 0.25, 0.25, 0.25], 1.3862943611198906),
    ([0.2, 0.2, 0.2, 0.2, 0.2], 1.6094379124341005),
    ([0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1], 2.3025850929940455),
)

    @test sum(Information.get_entropy, pr_) === re

    # 3.333 ns (0 allocations: 0 bytes)
    # 3.333 ns (0 allocations: 0 bytes)
    # 5.375 ns (0 allocations: 0 bytes)
    # 8.759 ns (0 allocations: 0 bytes)
    # 9.844 ns (0 allocations: 0 bytes)
    # 9.843 ns (0 allocations: 0 bytes)
    # 11.094 ns (0 allocations: 0 bytes)
    # 11.094 ns (0 allocations: 0 bytes)
    # 11.136 ns (0 allocations: 0 bytes)
    # 11.094 ns (0 allocations: 0 bytes)
    # 11.094 ns (0 allocations: 0 bytes)
    # 15.823 ns (0 allocations: 0 bytes)
    # 20.144 ns (0 allocations: 0 bytes)
    # 24.556 ns (0 allocations: 0 bytes)
    # 46.843 ns (0 allocations: 0 bytes)
    #@btime sum(Information.get_entropy, $pr_)

end

# ---- #

function plot(y_, na_, fu)

    Plot.plot(
        "",
        [Dict("name" => na_[id], "y" => y_[id]) for id in eachindex(y_)],
        Dict("title" => Dict("text" => string(fu))),
    )

end

# ---- #

for (n1_, n2_) in (([1, 2, 3], [2, 3, 4]), (kde(rand(10)).density, kde(randn(10)).density))

    for fu in (
        Information.get_kullback_leibler_divergence,
        Information.get_thermodynamic_depth,
        Information.get_thermodynamic_breadth,
    )

        plot((n1_, n2_, map(fu, n1_, n2_)), (1, 2, "Result"), fu)

    end

    for fu in (
        Information.get_antisymmetric_kullback_leibler_divergence,
        Information.get_symmetric_kullback_leibler_divergence,
    )

        n3_ = (n1_ + n2_) / 2

        plot((n1_, n2_, n3_, map(fu, n1_, n2_, n3_)), (1, 2, 3, "Result"), fu)

    end

end

# ---- #

# https://cdanielaam.medium.com/how-to-compare-and-evaluate-unsupervised-clustering-methods-84f3617e3769
for (jo, r1, r2) in (
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

    @test Information.get_mutual_information(jo) === r1

    @test isapprox(Information.get_mutual_information(jo, true), r2; atol = 1e-15)

    # 180.598 ns (2 allocations: 192 bytes)
    # 171.598 ns (0 allocations: 0 bytes)
    # 178.487 ns (2 allocations: 192 bytes)
    # 165.045 ns (0 allocations: 0 bytes)

    #@btime Information.get_mutual_information($jo)

    #@btime Information.get_mutual_information($jo, true)

end

# ---- #

for un in (10, 100, 1000, 10000, 100000)

    seed!(20240903)

    i1_ = rand(0:9, un)

    i2_ = rand(0:9, un)

    jo = Information._get_joint(NaN, i1_, i2_)

    @test isapprox(
        Information.get_mutual_information(jo),
        mutualinfo(i1_, i2_; normed = false);
        atol = 1e-14,
    )

    @test isapprox(
        Information.get_mutual_information(jo, true),
        mutualinfo(i1_, i2_);
        atol = 1e-14,
    )

    # 566.348 ns (7 allocations: 1.06 KiB)
    # 487.758 ns (9 allocations: 1.23 KiB)
    # 179.701 ns (2 allocations: 224 bytes)
    # 281.517 ns (0 allocations: 0 bytes)
    # 923.387 ns (7 allocations: 1.23 KiB)
    # 1.758 μs (9 allocations: 1.72 KiB)
    # 504.125 ns (2 allocations: 288 bytes)
    # 617.930 ns (0 allocations: 0 bytes)
    # 2.815 μs (7 allocations: 1.23 KiB)
    # 17.750 μs (9 allocations: 1.72 KiB)
    # 687.220 ns (2 allocations: 288 bytes)
    # 784.580 ns (0 allocations: 0 bytes)
    # 19.750 μs (7 allocations: 1.23 KiB)
    # 215.084 μs (9 allocations: 1.72 KiB)
    # 643.072 ns (2 allocations: 288 bytes)
    # 782.910 ns (0 allocations: 0 bytes)
    # 188.042 μs (7 allocations: 1.23 KiB)
    # 2.512 ms (9 allocations: 1.72 KiB)
    # 576.310 ns (2 allocations: 288 bytes)
    # 786.192 ns (0 allocations: 0 bytes)

    #@btime mutualinfo($i1_, $i2_)

    #@btime Information._get_joint(NaN, $i1_, $i2_)

    #@btime Information.get_mutual_information($jo)

    #@btime Information.get_mutual_information($jo, true)

end

# ---- #

for (i1_, i2_) in (([1], [1]), ([1, 1], [1, 1]), ([1, 2], [1, 1]), ([1, 2, 3], [1, 1, 1]))

    f1_ = convert(Vector{Float64}, i1_)

    f2_ = convert(Vector{Float64}, i2_)

    @test isnan(Information.get_information_coefficient(i1_, i2_))

    @test isnan(Information.get_information_coefficient(f1_, f2_))

    # 9.342 ns (0 allocations: 0 bytes)
    # 9.719 ns (0 allocations: 0 bytes)
    # 10.511 ns (0 allocations: 0 bytes)
    # 10.426 ns (0 allocations: 0 bytes)
    # 10.636 ns (0 allocations: 0 bytes)
    # 10.468 ns (0 allocations: 0 bytes)
    # 11.678 ns (0 allocations: 0 bytes)
    # 11.553 ns (0 allocations: 0 bytes)

    #@btime Information.get_information_coefficient($i1_, $i2_)

    #@btime Information.get_information_coefficient($f1_, $f2_)

end

# ---- #

for (i1_, i2_, r1, r2) in (
    ([1, 2], [1, 2], 1.0, 1.0),
    ([1, 2], [1, 3], 1.0, 1.0),
    ([1, 2, 3], [1, 1, 2], 0.8485384755376776, 0.8448096756916619),
    ([1, 2, 3], [1, 1, 3], 0.8485384755376776, 0.8448096756916618),
    ([1, 2, 3], [1, 2, 1], 0.0, 0.0),
    ([1, 2, 3], [1, 2, 2], 0.8485384755376776, 0.8448096756916624),
    ([1, 2, 3], [1, 2, 3], 1.0, 1.0),
    ([1, 2, 3], [1, 3, 1], 0.0, 0.0),
    ([1, 2, 3], [1, 3, 2], 0.9428090415820634, 0.9356710796440404),
    ([1, 2, 3], [1, 3, 3], 0.8485384755376776, 0.8448096756916622),
    ([1, 2, 1, 2], [1, 2, 1, 2], 1.0, 1.0),
    ([1, 2, 1, 2], [1, 3, 1, 3], 1.0, 1.0),
    ([1, 2, 1, 2], [1, 2, 1, 3], 0.8660254037844386, 0.8619662349401314),
    ([1, 2, 1, 2], [1, 3, 1, 2], 0.8660254037844386, 0.8619662349401314),
    ([1, 2, 1, 2], [2, 1, 2, 1], -1.0, -1.0),
    ([1, 2, 1, 2], [3, 1, 3, 1], -1.0, -1.0),
    ([1, 2, 1, 2], [2, 1, 3, 1], -0.8660254037844386, -0.8619662349401319),
    ([1, 2, 1, 2], [3, 1, 2, 1], -0.8660254037844386, -0.8619662349401319),
)

    f1_ = convert(Vector{Float64}, i1_)

    f2_ = convert(Vector{Float64}, i2_)

    @test isapprox(Information.get_information_coefficient(i1_, i2_), r1; atol = 1e-15)

    @test isapprox(Information.get_information_coefficient(f1_, f2_), r2; atol = 1e-14)

    # 10.636 ns (0 allocations: 0 bytes)
    # 10.385 ns (0 allocations: 0 bytes)
    # 10.552 ns (0 allocations: 0 bytes)
    # 10.468 ns (0 allocations: 0 bytes)
    # 671.980 ns (17 allocations: 1.33 KiB)
    # 26.708 μs (33 allocations: 44.83 KiB)
    # 699.338 ns (17 allocations: 1.33 KiB)
    # 26.625 μs (33 allocations: 44.83 KiB)
    # 674.497 ns (17 allocations: 1.33 KiB)
    # 28.208 μs (33 allocations: 44.83 KiB)
    # 699.324 ns (17 allocations: 1.33 KiB)
    # 26.583 μs (33 allocations: 44.83 KiB)
    # 11.971 ns (0 allocations: 0 bytes)
    # 11.427 ns (0 allocations: 0 bytes)
    # 699.107 ns (17 allocations: 1.33 KiB)
    # 28.375 μs (33 allocations: 44.83 KiB)
    # 704.918 ns (17 allocations: 1.34 KiB)
    # 28.375 μs (33 allocations: 44.83 KiB)
    # 673.013 ns (17 allocations: 1.33 KiB)
    # 26.583 μs (33 allocations: 44.83 KiB)
    # 12.846 ns (0 allocations: 0 bytes)
    # 12.053 ns (0 allocations: 0 bytes)
    # 12.804 ns (0 allocations: 0 bytes)
    # 11.970 ns (0 allocations: 0 bytes)
    # 689.061 ns (17 allocations: 1.33 KiB)
    # 26.291 μs (33 allocations: 44.86 KiB)
    # 688.298 ns (17 allocations: 1.33 KiB)
    # 26.250 μs (33 allocations: 44.86 KiB)
    # 12.846 ns (0 allocations: 0 bytes)
    # 12.053 ns (0 allocations: 0 bytes)
    # 12.805 ns (0 allocations: 0 bytes)
    # 12.053 ns (0 allocations: 0 bytes)
    # 688.368 ns (17 allocations: 1.33 KiB)
    # 26.292 μs (33 allocations: 44.86 KiB)
    # 687.919 ns (17 allocations: 1.33 KiB)
    # 26.458 μs (33 allocations: 44.86 KiB)

    #@btime Information.get_information_coefficient($i1_, $i2_)

    #@btime Information.get_information_coefficient($f1_, $f2_)

end

# ---- #

const FU_ = Euclidean(), CorrDist(), Information.InformationDistance()

# ---- #

for (n1_, n2_, re_...) in (
    ([1, 2], [1, 2], 0.0, 2.220446049250313e-16, 0.0),
    ([1, 2], [2, 1], 1.4142135623730951, 1.9999999999999998, 2.0),
    ([1, 2, 3], [1, 2, 3], 0.0, 2.220446049250313e-16, 0.0),
    ([1, 2, 3], [3, 2, 1], 2.8284271247461903, 1.9999999999999998, 2.0),
    ([1, 2, 3, 4], [1, 2, 3, 4], 0.0, 2.220446049250313e-16, 0.0),
    ([1, 2, 3, 4], [4, 3, 2, 1], 4.47213595499958, 1.9999999999999998, 2.0),
)

    for (fu, re) in zip(FU_, re_)

        @test fu(n1_, n2_) === re

        # 3.083 ns (0 allocations: 0 bytes)
        # 44.149 ns (2 allocations: 160 bytes)
        # 10.552 ns (0 allocations: 0 bytes)
        # 3.083 ns (0 allocations: 0 bytes)
        # 44.151 ns (2 allocations: 160 bytes)
        # 10.636 ns (0 allocations: 0 bytes)
        # 3.167 ns (0 allocations: 0 bytes)
        # 45.205 ns (2 allocations: 160 bytes)
        # 11.678 ns (0 allocations: 0 bytes)
        # 3.208 ns (0 allocations: 0 bytes)
        # 45.205 ns (2 allocations: 160 bytes)
        # 11.803 ns (0 allocations: 0 bytes)
        # 3.167 ns (0 allocations: 0 bytes)
        # 44.402 ns (2 allocations: 192 bytes)
        # 12.846 ns (0 allocations: 0 bytes)
        # 3.208 ns (0 allocations: 0 bytes)
        # 44.405 ns (2 allocations: 192 bytes)
        # 12.971 ns (0 allocations: 0 bytes)
        #@btime $fu($n1_, $n2_)

    end

end

# ---- #

for un in (10, 100, 1000)

    seed!(20240201)

    nu___ = rand(un), rand(un), rand(un)

    for fu in FU_

        # 37.467 ns (1 allocation: 128 bytes)
        # 178.890 ns (7 allocations: 992 bytes)
        # 83.708 μs (100 allocations: 134.98 KiB)
        # 78.479 ns (1 allocation: 128 bytes)
        # 408.801 ns (7 allocations: 5.38 KiB)
        # 98.042 μs (100 allocations: 139.39 KiB)
        # 879.808 ns (1 allocation: 128 bytes)
        # 3.255 μs (7 allocations: 48.12 KiB)
        # 246.041 μs (103 allocations: 182.19 KiB)
        #@btime pairwise($fu, $nu___)

    end

end

# ---- #

function Information.get_entropy(pr)

    iszero(pr) ? 0.0 : -pr * log2(pr)

end

# ---- #

const JO = [
    1/8 1/16 1/16 1/4
    1/16 1/8 1/16 0
    1/32 1/32 1/16 0
    1/32 1/32 1/16 0
]

# ---- #

const P1_ = Information._marginalize(eachrow, JO)

@test P1_ == [1 / 2, 1 / 4, 1 / 8, 1 / 8]

# ---- #

const P2_ = Information._marginalize(eachcol, JO)

@test P2_ == [1 / 4, 1 / 4, 1 / 4, 1 / 4]

# ---- #

const E1 = Information._marginalize_entropy_sum(eachrow, JO)

@test E1 === 7 / 4

# ---- #

const E2 = Information._marginalize_entropy_sum(eachcol, JO)

@test E2 === 2.0

# ---- #

const EJ = sum(Information.get_entropy, JO)

@test EJ === 27 / 8

# ---- #

const E12 = EJ - E2

@test E12 ===
      sum(
          p2 * sum(Information.get_entropy, co / p2) for (p2, co) in zip(P2_, eachcol(JO))
      ) ===
      11 / 8

# ---- #

const E21 = EJ - E1

@test E21 ===
      sum(
          p1 * sum(Information.get_entropy, ro / p1) for (p1, ro) in zip(P1_, eachrow(JO))
      ) ===
      13 / 8

# ---- #

const MU = E1 + E2 - EJ

@test MU === E1 - E12 === E2 - E21 === 3 / 8
