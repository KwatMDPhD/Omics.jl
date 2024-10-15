using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Clustering: mutualinfo

using KernelDensity: kde

using Random: seed!

# ---- #

for (pr_, re) in (
    ([0], 0.0),
    ([0, 0], 0.0),
    ([1], -0.0),
    ([1, 1], -0.0),
    ([0.001, 0.999], 0.011407757737461138),
    ([0.01, 0.99], 0.08079313589591118),
    ([0.1, 0.9], 0.4689955935892812),
    ([0.2, 0.8], 0.7219280948873623),
    ([0.3, 0.7], 0.8812908992306927),
    ([0.4, 0.6], 0.9709505944546686),
    ([0.5, 0.5], 1.0),
    ([1 / 3, 1 / 3, 1 / 3], 1.584962500721156),
    ([0.25, 0.25, 0.25, 0.25], 2.0),
    ([0.2, 0.2, 0.2, 0.2, 0.2], 2.321928094887362),
    ([0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1], 3.321928094887362),
)

    @test sum(Omics.Information.get_shannon_entropy, pr_) === re

    # 3.625 ns (0 allocations: 0 bytes)
    # 4.250 ns (0 allocations: 0 bytes)
    # 6.750 ns (0 allocations: 0 bytes)
    # 10.468 ns (0 allocations: 0 bytes)
    # 11.094 ns (0 allocations: 0 bytes)
    # 11.052 ns (0 allocations: 0 bytes)
    # 12.303 ns (0 allocations: 0 bytes)
    # 12.303 ns (0 allocations: 0 bytes)
    # 12.304 ns (0 allocations: 0 bytes)
    # 12.304 ns (0 allocations: 0 bytes)
    # 12.304 ns (0 allocations: 0 bytes)
    # 16.992 ns (0 allocations: 0 bytes)
    # 21.690 ns (0 allocations: 0 bytes)
    # 26.481 ns (0 allocations: 0 bytes)
    # 50.532 ns (0 allocations: 0 bytes)
    #@btime sum(Omics.Information.get_shannon_entropy, $pr_)

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

    # 151.380 ns (4 allocations: 192 bytes)
    # 169.445 ns (0 allocations: 0 bytes)
    # 149.226 ns (4 allocations: 192 bytes)
    # 166.442 ns (0 allocations: 0 bytes)

    #@btime Omics.Information.get_mutual_information($jo)

    #@btime Omics.Information.get_mutual_information($jo, true)

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

    # 480.344 ns (6 allocations: 1.00 KiB)
    # 492.401 ns (12 allocations: 1.50 KiB)
    # 183.065 ns (4 allocations: 224 bytes)
    # 208.858 ns (0 allocations: 0 bytes)
    # 832.750 ns (6 allocations: 1.23 KiB)
    # 1.608 μs (12 allocations: 2.53 KiB)
    # 516.057 ns (4 allocations: 288 bytes)
    # 551.695 ns (0 allocations: 0 bytes)
    # 2.769 μs (6 allocations: 1.23 KiB)
    # 13.500 μs (12 allocations: 2.53 KiB)
    # 697.074 ns (4 allocations: 288 bytes)
    # 721.809 ns (0 allocations: 0 bytes)
    # 20.167 μs (6 allocations: 1.23 KiB)
    # 199.792 μs (12 allocations: 2.53 KiB)
    # 653.037 ns (4 allocations: 288 bytes)
    # 721.409 ns (0 allocations: 0 bytes)
    # 193.792 μs (6 allocations: 1.23 KiB)
    # 2.407 ms (12 allocations: 2.53 KiB)
    # 573.087 ns (4 allocations: 288 bytes)
    # 720.865 ns (0 allocations: 0 bytes)

    #@btime mutualinfo($i1_, $i2_)

    #@btime Omics.Information._get_joint(NaN, $i1_, $i2_)

    #@btime Omics.Information.get_mutual_information($jo)

    #@btime Omics.Information.get_mutual_information($jo, true)

end

# ---- #

for (i1_, i2_) in (([1], [1]), ([1, 1], [1, 1]), ([1, 2], [1, 1]), ([1, 2, 3], [1, 1, 1]))

    f1_ = convert(Vector{Float64}, i1_)

    f2_ = convert(Vector{Float64}, i2_)

    @test isnan(Omics.Information.get_information_coefficient(i1_, i2_))

    @test isnan(Omics.Information.get_information_coefficient(f1_, f2_))

    # 9.635 ns (0 allocations: 0 bytes)
    # 9.551 ns (0 allocations: 0 bytes)
    # 10.969 ns (0 allocations: 0 bytes)
    # 10.552 ns (0 allocations: 0 bytes)
    # 10.969 ns (0 allocations: 0 bytes)
    # 10.511 ns (0 allocations: 0 bytes)
    # 12.095 ns (0 allocations: 0 bytes)
    # 11.595 ns (0 allocations: 0 bytes)

    #@btime Omics.Information.get_information_coefficient($i1_, $i2_)

    #@btime Omics.Information.get_information_coefficient($f1_, $f2_)

end

# ---- #

for (i1_, i2_, r1, r2) in (
    ([1, 2], [1, 2], 1.0, 1.0),
    ([1, 2], [1, 3], 1.0, 1.0),
    ([1, 2, 3], [1, 1, 2], 0.9168644108463501, 0.9140184400703145),
    ([1, 2, 3], [1, 1, 3], 0.9168644108463501, 0.9140184400703149),
    ([1, 2, 3], [1, 2, 1], 0.0, 0.0),
    ([1, 2, 3], [1, 2, 2], 0.9168644108463501, 0.9140184400703141),
    ([1, 2, 3], [1, 2, 3], 1.0, 1.0),
    ([1, 2, 3], [1, 3, 1], 0.0, 0.0),
    ([1, 2, 3], [1, 3, 2], 0.9787712969683778, 0.9749301137414429),
    ([1, 2, 3], [1, 3, 3], 0.9168644108463501, 0.9140184400703142),
    ([1, 2, 1, 2], [1, 2, 1, 2], 1.0, 1.0),
    ([1, 2, 1, 2], [1, 3, 1, 3], 1.0, 1.0),
    ([1, 2, 1, 2], [1, 2, 1, 3], 0.9298734950321937, 0.9269049805641629),
    ([1, 2, 1, 2], [1, 3, 1, 2], 0.9298734950321937, 0.9269049805641629),
    ([1, 2, 1, 2], [2, 1, 2, 1], -1.0, -1.0),
    ([1, 2, 1, 2], [3, 1, 3, 1], -1.0, -1.0),
    ([1, 2, 1, 2], [2, 1, 3, 1], -0.9298734950321937, -0.9269049805641629),
    ([1, 2, 1, 2], [3, 1, 2, 1], -0.9298734950321937, -0.9269049805641629),
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

    # 11.011 ns (0 allocations: 0 bytes)
    # 10.552 ns (0 allocations: 0 bytes)
    # 11.011 ns (0 allocations: 0 bytes)
    # 10.511 ns (0 allocations: 0 bytes)
    # 444.869 ns (12 allocations: 960 bytes)
    # 27.500 μs (54 allocations: 43.86 KiB)
    # 447.182 ns (12 allocations: 960 bytes)
    # 27.875 μs (54 allocations: 43.86 KiB)
    # 434.343 ns (12 allocations: 960 bytes)
    # 29.167 μs (54 allocations: 43.86 KiB)
    # 435.372 ns (12 allocations: 960 bytes)
    # 27.500 μs (54 allocations: 43.86 KiB)
    # 12.095 ns (0 allocations: 0 bytes)
    # 11.595 ns (0 allocations: 0 bytes)
    # 437.604 ns (12 allocations: 960 bytes)
    # 29.666 μs (54 allocations: 43.86 KiB)
    # 453.472 ns (12 allocations: 992 bytes)
    # 29.375 μs (54 allocations: 43.86 KiB)
    # 437.183 ns (12 allocations: 960 bytes)
    # 27.541 μs (54 allocations: 43.86 KiB)
    # 13.304 ns (0 allocations: 0 bytes)
    # 12.679 ns (0 allocations: 0 bytes)
    # 13.179 ns (0 allocations: 0 bytes)
    # 12.763 ns (0 allocations: 0 bytes)
    # 468.428 ns (12 allocations: 960 bytes)
    # 27.083 μs (54 allocations: 43.89 KiB)
    # 458.118 ns (12 allocations: 960 bytes)
    # 27.083 μs (54 allocations: 43.89 KiB)
    # 13.277 ns (0 allocations: 0 bytes)
    # 12.679 ns (0 allocations: 0 bytes)
    # 13.179 ns (0 allocations: 0 bytes)
    # 12.763 ns (0 allocations: 0 bytes)
    # 456.633 ns (12 allocations: 960 bytes)
    # 27.083 μs (54 allocations: 43.89 KiB)
    # 473.799 ns (12 allocations: 960 bytes)
    # 27.083 μs (54 allocations: 43.89 KiB)

    #@btime Omics.Information.get_information_coefficient($i1_, $i2_)

    #@btime Omics.Information.get_information_coefficient($f1_, $f2_)

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
