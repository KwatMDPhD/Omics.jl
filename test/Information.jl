using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Clustering: mutualinfo

using Distances: CorrDist, Euclidean, pairwise

using KernelDensity: kde

using Random: seed!

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

    @test sum(Omics.Information.get_shannon_entropy, pr_) === re

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
    @btime sum(Omics.Information.get_shannon_entropy, $pr_)

end

# ---- #

function plot(y_, na_, fu)

    Omics.Plot.plot(
        "",
        [Dict("name" => na_[id], "y" => y_[id]) for id in eachindex(y_)],
        Dict("title" => Dict("text" => string(fu))),
    )

end

# ---- #

for (n1_, n2_) in (([1, 2, 3], [2, 3, 4]), (kde(rand(10)).density, kde(randn(10)).density))

    for fu in (
        Omics.Information.get_kullback_leibler_divergence,
        Omics.Information.get_thermodynamic_depth,
        Omics.Information.get_thermodynamic_breadth,
    )

        plot((n1_, n2_, map(fu, n1_, n2_)), (1, 2, "Result"), fu)

    end

    for fu in (
        Omics.Information.get_antisymmetric_kullback_leibler_divergence,
        Omics.Information.get_symmetric_kullback_leibler_divergence,
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

    @test Omics.Information.get_mutual_information(jo) === r1

    @test isapprox(Omics.Information.get_mutual_information(jo, true), r2; atol = 1e-15)

    # 121.908 ns (4 allocations: 192 bytes)
    # 140.104 ns (0 allocations: 0 bytes)
    # 120.847 ns (4 allocations: 192 bytes)
    # 140.399 ns (0 allocations: 0 bytes)

    @btime Omics.Information.get_mutual_information($jo)

    @btime Omics.Information.get_mutual_information($jo, true)

end

# ---- #

for un in (10, 100, 1000, 10000, 100000)

    seed!(20240903)

    i1_ = rand(0:9, un)

    i2_ = rand(0:9, un)

    jo = Omics.Information._get_joint(NaN, i1_, i2_)

    @test isapprox(
        Omics.Information.get_mutual_information(jo),
        mutualinfo(i1_, i2_; normed = false);
        atol = 1e-14,
    )

    @test isapprox(
        Omics.Information.get_mutual_information(jo, true),
        mutualinfo(i1_, i2_);
        atol = 1e-14,
    )

    # 486.686 ns (6 allocations: 1.00 KiB)
    # 448.391 ns (12 allocations: 1.50 KiB)
    # 149.654 ns (4 allocations: 224 bytes)
    # 184.934 ns (0 allocations: 0 bytes)
    # 843.887 ns (6 allocations: 1.23 KiB)
    # 1.554 μs (12 allocations: 2.53 KiB)
    # 485.687 ns (4 allocations: 288 bytes)
    # 506.689 ns (0 allocations: 0 bytes)
    # 2.764 μs (6 allocations: 1.23 KiB)
    # 15.458 μs (12 allocations: 2.53 KiB)
    # 664.032 ns (4 allocations: 288 bytes)
    # 661.194 ns (0 allocations: 0 bytes)
    # 20.209 μs (6 allocations: 1.23 KiB)
    # 199.500 μs (12 allocations: 2.53 KiB)
    # 621.605 ns (4 allocations: 288 bytes)
    # 661.719 ns (0 allocations: 0 bytes)
    # 193.875 μs (6 allocations: 1.23 KiB)
    # 2.410 ms (12 allocations: 2.53 KiB)
    # 547.460 ns (4 allocations: 288 bytes)
    # 662.472 ns (0 allocations: 0 bytes)

    @btime mutualinfo($i1_, $i2_)

    @btime Omics.Information._get_joint(NaN, $i1_, $i2_)

    @btime Omics.Information.get_mutual_information($jo)

    @btime Omics.Information.get_mutual_information($jo, true)

end

# ---- #

for (i1_, i2_) in (([1], [1]), ([1, 1], [1, 1]), ([1, 2], [1, 1]), ([1, 2, 3], [1, 1, 1]))

    f1_ = convert(Vector{Float64}, i1_)

    f2_ = convert(Vector{Float64}, i2_)

    @test isnan(Omics.Information.get_information_coefficient(i1_, i2_))

    @test isnan(Omics.Information.get_information_coefficient(f1_, f2_))

    # 30.055 ns (0 allocations: 0 bytes)
    # 9.510 ns (0 allocations: 0 bytes)
    # 39.613 ns (0 allocations: 0 bytes)
    # 10.552 ns (0 allocations: 0 bytes)
    # 39.862 ns (0 allocations: 0 bytes)
    # 10.552 ns (0 allocations: 0 bytes)
    # 29.355 ns (0 allocations: 0 bytes)
    # 11.553 ns (0 allocations: 0 bytes)

    @btime Omics.Information.get_information_coefficient($i1_, $i2_)

    @btime Omics.Information.get_information_coefficient($f1_, $f2_)

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

    @test isapprox(
        Omics.Information.get_information_coefficient(i1_, i2_),
        r1;
        atol = 1e-15,
    )

    @test isapprox(
        Omics.Information.get_information_coefficient(f1_, f2_),
        r2;
        atol = 1e-14,
    )

    # 39.782 ns (0 allocations: 0 bytes)
    # 10.552 ns (0 allocations: 0 bytes)
    # 33.208 ns (0 allocations: 0 bytes)
    # 10.552 ns (0 allocations: 0 bytes)
    # 408.709 ns (12 allocations: 960 bytes)
    # 27.417 μs (54 allocations: 43.86 KiB)
    # 412.271 ns (12 allocations: 960 bytes)
    # 27.375 μs (54 allocations: 43.86 KiB)
    # 417.296 ns (12 allocations: 960 bytes)
    # 28.959 μs (54 allocations: 43.86 KiB)
    # 420.643 ns (12 allocations: 960 bytes)
    # 27.291 μs (54 allocations: 43.86 KiB)
    # 29.313 ns (0 allocations: 0 bytes)
    # 11.637 ns (0 allocations: 0 bytes)
    # 413.317 ns (12 allocations: 960 bytes)
    # 29.042 μs (54 allocations: 43.86 KiB)
    # 414.362 ns (12 allocations: 992 bytes)
    # 29.042 μs (54 allocations: 43.86 KiB)
    # 419.181 ns (12 allocations: 960 bytes)
    # 27.250 μs (54 allocations: 43.86 KiB)
    # 30.611 ns (0 allocations: 0 bytes)
    # 12.721 ns (0 allocations: 0 bytes)
    # 30.580 ns (0 allocations: 0 bytes)
    # 12.679 ns (0 allocations: 0 bytes)
    # 437.081 ns (12 allocations: 960 bytes)
    # 26.958 μs (54 allocations: 43.89 KiB)
    # 424.623 ns (12 allocations: 960 bytes)
    # 26.750 μs (54 allocations: 43.89 KiB)
    # 30.570 ns (0 allocations: 0 bytes)
    # 12.638 ns (0 allocations: 0 bytes)
    # 30.570 ns (0 allocations: 0 bytes)
    # 12.763 ns (0 allocations: 0 bytes)
    # 427.399 ns (12 allocations: 960 bytes)
    # 26.959 μs (54 allocations: 43.89 KiB)
    # 441.416 ns (12 allocations: 960 bytes)
    # 26.916 μs (54 allocations: 43.89 KiB)

    @btime Omics.Information.get_information_coefficient($i1_, $i2_)

    @btime Omics.Information.get_information_coefficient($f1_, $f2_)

end

# ---- #

const FU_ = Euclidean(), CorrDist(), Omics.Information.InformationDistance()

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

        # 3.333 ns (0 allocations: 0 bytes)
        # 76.182 ns (4 allocations: 160 bytes)
        # 40.494 ns (0 allocations: 0 bytes)
        # 3.333 ns (0 allocations: 0 bytes)
        # 76.217 ns (4 allocations: 160 bytes)
        # 41.835 ns (0 allocations: 0 bytes)
        # 4.583 ns (0 allocations: 0 bytes)
        # 76.738 ns (4 allocations: 160 bytes)
        # 29.355 ns (0 allocations: 0 bytes)
        # 4.583 ns (0 allocations: 0 bytes)
        # 77.473 ns (4 allocations: 160 bytes)
        # 29.355 ns (0 allocations: 0 bytes)
        # 3.625 ns (0 allocations: 0 bytes)
        # 78.366 ns (4 allocations: 192 bytes)
        # 30.570 ns (0 allocations: 0 bytes)
        # 3.666 ns (0 allocations: 0 bytes)
        # 78.441 ns (4 allocations: 192 bytes)
        # 30.569 ns (0 allocations: 0 bytes)
        @btime $fu($n1_, $n2_)

    end

end

# ---- #

for un in (10, 100, 1000)

    seed!(20240201)

    nu___ = rand(un), rand(un), rand(un)

    for fu in FU_

        # 46.512 ns (2 allocations: 144 bytes)
        # 266.071 ns (14 allocations: 1008 bytes)
        # 85.625 μs (164 allocations: 132.09 KiB)
        # 77.712 ns (2 allocations: 144 bytes)
        # 411.849 ns (14 allocations: 5.58 KiB)
        # 99.000 μs (164 allocations: 136.69 KiB)
        # 472.148 ns (2 allocations: 144 bytes)
        # 2.259 μs (20 allocations: 47.77 KiB)
        # 257.042 μs (173 allocations: 178.92 KiB)
        @btime pairwise($fu, $nu___)

    end

end

# ---- #

function Omics.Information.get_shannon_entropy(pr)

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

const P1_ = Omics.Information._marginalize(eachrow, JO)

@test P1_ == [1 / 2, 1 / 4, 1 / 8, 1 / 8]

# ---- #

const P2_ = Omics.Information._marginalize(eachcol, JO)

@test P2_ == [1 / 4, 1 / 4, 1 / 4, 1 / 4]

# ---- #

const E1 = Omics.Information._marginalize_entropy_sum(eachrow, JO)

@test E1 === 7 / 4

# ---- #

const E2 = Omics.Information._marginalize_entropy_sum(eachcol, JO)

@test E2 === 2.0

# ---- #

const EJ = sum(Omics.Information.get_shannon_entropy, JO)

@test EJ === 27 / 8

# ---- #

const E12 = EJ - E2

@test E12 ===
      sum(
          p2 * sum(Omics.Information.get_shannon_entropy, co / p2) for
          (p2, co) in zip(P2_, eachcol(JO))
      ) ===
      11 / 8

# ---- #

const E21 = EJ - E1

@test E21 ===
      sum(
          p1 * sum(Omics.Information.get_shannon_entropy, ro / p1) for
          (p1, ro) in zip(P1_, eachrow(JO))
      ) ===
      13 / 8

# ---- #

const MU = E1 + E2 - EJ

@test MU === E1 - E12 === E2 - E21 === 3 / 8
