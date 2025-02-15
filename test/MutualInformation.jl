using Clustering: mutualinfo

using Random: seed!

using Statistics: cor

using Test: @test

using Omics

# ---- #

const PR = [
    1/8 1/16 1/16 1/4
    1/16 1/8 1/16 0
    1/32 1/32 1/16 0
    1/32 1/32 1/16 0
]

# ---- #

const P1_ = map(sum, eachrow(PR))

@test P1_ == [1 / 2, 1 / 4, 1 / 8, 1 / 8]

# ---- #

const P2_ = map(sum, eachcol(PR))

@test P2_ == [1 / 4, 1 / 4, 1 / 4, 1 / 4]

# ---- #

const E1 = sum(Omics.Entropy.ge, P1_)

@test E1 === Omics.Entropy.ge(eachrow, PR) === 7 / 4

# ---- #

const E2 = sum(Omics.Entropy.ge, P2_)

@test E2 === Omics.Entropy.ge(eachcol, PR) === 2.0

# ---- #

const E3 = sum(Omics.Entropy.ge, PR)

@test E3 === 27 / 8

# ---- #

# TODO: Understand.
const E4 = E3 - E1

@test E4 ===
      sum(pr * sum(Omics.Entropy.ge, pr_ / pr) for (pr, pr_) in zip(P1_, eachrow(PR))) ===
      13 / 8

# ---- #

# TODO: Understand.
const E5 = E3 - E2

@test E5 ===
      sum(pr * sum(Omics.Entropy.ge, pr_ / pr) for (pr, pr_) in zip(P2_, eachcol(PR))) ===
      11 / 8

# ---- #

const MU = E1 + E2 - E3

@test MU === E1 - E5 === E2 - E4 === 3 / 8

# ---- #

# 96.017 ns (4 allocations: 1.84 KiB)
# 235.431 ns (4 allocations: 1.84 KiB)
# 1.742 μs (4 allocations: 1.84 KiB)
# 17.000 μs (4 allocations: 1.84 KiB)

for um in (10, 100, 1000, 10000)

    seed!(20241021)

    #@btime Omics.MutualInformation._get_density($(rand(0:9, um)), $(rand(0:9, um)), NaN)

end

# ---- #

# 96.017 ns (4 allocations: 1.84 KiB)
# 235.431 ns (4 allocations: 1.84 KiB)
# 1.742 μs (4 allocations: 1.84 KiB)
# 17.000 μs (4 allocations: 1.84 KiB)

for um in (10, 100, 1000, 10000)

    seed!(20241021)

    n1_ = randn(um)

    n2_ = randn(um)

    #@btime Omics.MutualInformation._get_density($n1_, $n2_, $(cor(n1_, n2_)))

end

# ---- #

# 231.153 ns (4 allocations: 288 bytes)
# 274.484 ns (0 allocations: 0 bytes)
# 501.289 ns (4 allocations: 288 bytes)
# 537.037 ns (0 allocations: 0 bytes)
# 702.055 ns (4 allocations: 288 bytes)
# 709.220 ns (0 allocations: 0 bytes)
# 668.790 ns (4 allocations: 288 bytes)
# 712.793 ns (0 allocations: 0 bytes)

for um in (10, 100, 1000, 10000)

    seed!(20241021)

    pr = Omics.Normalization.normalize_with_sum!(
        Omics.MutualInformation._get_density(rand(0:9, um), rand(0:9, um), NaN),
    )

    #@btime Omics.MutualInformation.get_mutual_information($pr)

    #@btime Omics.MutualInformation.get_mutual_information($pr, false)

end

# ---- #

# 6.933 μs (4 allocations: 640 bytes)
# 6.117 μs (0 allocations: 0 bytes)
# 6.150 μs (4 allocations: 640 bytes)
# 5.833 μs (0 allocations: 0 bytes)
# 5.715 μs (4 allocations: 640 bytes)
# 5.653 μs (0 allocations: 0 bytes)
# 5.764 μs (4 allocations: 640 bytes)
# 5.903 μs (0 allocations: 0 bytes)

for um in (10, 100, 1000, 10000)

    seed!(20241021)

    n1_ = randn(um)

    n2_ = randn(um)

    pr = Omics.Normalization.normalize_with_sum!(
        Omics.MutualInformation._get_density(n1_, n2_, cor(n1_, n2_)),
    )

    #@btime Omics.MutualInformation.get_mutual_information($pr)

    #@btime Omics.MutualInformation.get_mutual_information($pr, false)

end

# ---- #

for (n1_, n2_, r1, r2) in (
    ([1, 2], [1, 2], 1.0, 1.0),
    ([1, 2], [1, 3], 1.0, 1.0),
    ([1, 2, 3], [1, 1, 2], 0.9168644108463501, 0.9140184400703139),
    ([1, 2, 3], [1, 1, 3], 0.9168644108463501, 0.9140184400703143),
    ([1, 2, 3], [1, 2, 1], 0.0, 0.0),
    ([1, 2, 3], [1, 2, 2], 0.9168644108463501, 0.9140184400703139),
    ([1, 2, 3], [1, 2, 3], 1.0, 1.0),
    ([1, 2, 3], [1, 3, 1], 0.0, 0.0),
    ([1, 2, 3], [1, 3, 2], 0.9787712969683778, 0.9749301137414429),
    ([1, 2, 3], [1, 3, 3], 0.9168644108463501, 0.9140184400703135),
    ([1, 2, 1, 2], [1, 2, 1, 2], 1.0, 1.0),
    ([1, 2, 1, 2], [1, 3, 1, 3], 1.0, 1.0),
    ([1, 2, 1, 2], [1, 2, 1, 3], 0.9298734950321937, 0.9269049805641628),
    ([1, 2, 1, 2], [1, 3, 1, 2], 0.9298734950321937, 0.9269049805641628),
    ([1, 2, 1, 2], [2, 1, 2, 1], -1.0, -1.0),
    ([1, 2, 1, 2], [3, 1, 3, 1], -1.0, -1.0),
    ([1, 2, 1, 2], [2, 1, 3, 1], -0.9298734950321937, -0.9269049805641624),
    ([1, 2, 1, 2], [3, 1, 2, 1], -0.9298734950321937, -0.9269049805641624),
)

    @test Omics.MutualInformation.get_information_coefficient(n1_, n2_) === r1

    @test Omics.MutualInformation.get_information_coefficient(
        convert(Vector{Float64}, n1_),
        convert(Vector{Float64}, n2_),
    ) === r2

end

# ---- #

# 438.970 ns (4 allocations: 1.84 KiB)
# 27.833 μs (54 allocations: 43.98 KiB)
# 939.115 ns (4 allocations: 1.84 KiB)
# 32.708 μs (54 allocations: 45.52 KiB)
# 3.672 μs (4 allocations: 1.84 KiB)
# 80.125 μs (57 allocations: 59.59 KiB)
# 29.375 μs (4 allocations: 1.84 KiB)
# 992.333 μs (57 allocations: 200.09 KiB)

for um in (10, 100, 1000, 10000)

    seed!(20241021)

    #@btime Omics.MutualInformation.get_information_coefficient(
    #    $(rand(0:9, um)),
    #    $(rand(0:9, um)),
    #)

    #@btime Omics.MutualInformation.get_information_coefficient($(randn(um)), $(randn(um)))

end

# ---- #

function Omics.Entropy.ge(pr)

    iszero(pr) ? 0.0 : -pr * log(pr)

end

function Omics.Information.get_kullback_leibler_divergence(n1, n2)

    n1 * log(n1 / n2)

end

# ---- #

# https://cdanielaam.medium.com/how-to-compare-and-evaluate-unsupervised-clustering-methods-84f3617e3769

for pr in (
    [
        0.2 0 0 0 0
        0 0.2 0 0 0
        0.001 0 0.199 0 0
        0.002 0 0 0.198 0
        0.006 0.002 0 0 0.192
    ],
    [
        0.2 0 0 0 0
        0.001 0 0.199 0 0
        0.006 0.002 0 0 0.192
        0.002 0 0 0.198 0
        0 0.2 0 0 0
    ],
)

    re = 1.5534700710552343

    @test Omics.MutualInformation.get_mutual_information(pr) === re

    @test isapprox(Omics.MutualInformation.get_mutual_information(pr, false), re)

    @test isapprox(
        Omics.MutualInformation.get_mutual_information(pr, true),
        0.9653404496537963,
    )

end

# ---- #

# 451.563 ns (6 allocations: 1.00 KiB)
# 130.523 ns (4 allocations: 1.41 KiB)
# 200.847 ns (4 allocations: 272 bytes)
# 258.436 ns (0 allocations: 0 bytes)
# 810.081 ns (6 allocations: 1.23 KiB)
# 311.159 ns (4 allocations: 1.84 KiB)
# 477.138 ns (4 allocations: 288 bytes)
# 525.743 ns (0 allocations: 0 bytes)
# 2.509 μs (6 allocations: 1.23 KiB)
# 1.817 μs (4 allocations: 1.84 KiB)
# 656.123 ns (4 allocations: 288 bytes)
# 681.020 ns (0 allocations: 0 bytes)
# 17.750 μs (6 allocations: 1.23 KiB)
# 17.083 μs (4 allocations: 1.84 KiB)
# 613.811 ns (4 allocations: 288 bytes)
# 683.503 ns (0 allocations: 0 bytes)

for um in (10, 100, 1000, 10000)

    seed!(20240903)

    n1_ = rand(0:9, um)

    n2_ = rand(0:9, um)

    re = mutualinfo(n1_, n2_; normed = false)

    pr = Omics.Normalization.normalize_with_sum!(
        Omics.MutualInformation._get_density(n1_, n2_, NaN),
    )

    @test isapprox(Omics.MutualInformation.get_mutual_information(pr), re)

    @test isapprox(Omics.MutualInformation.get_mutual_information(pr, false), re)

    #@btime mutualinfo($n1_, $n2_; normed = false)

    #@btime Omics.Normalization.normalize_with_sum!(
    #    Omics.MutualInformation._get_density($n1_, $n2_, NaN),
    #)

    #@btime Omics.MutualInformation.get_mutual_information($pr)

    #@btime Omics.MutualInformation.get_mutual_information($pr, false)

    @test isapprox(
        Omics.MutualInformation.get_mutual_information(pr, true),
        mutualinfo(n1_, n2_),
    )

end
