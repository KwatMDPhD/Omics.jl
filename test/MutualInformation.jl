using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Clustering: mutualinfo

using Random: seed!

using Statistics: cor

# ---- #

const JO = [
    1/8 1/16 1/16 1/4
    1/16 1/8 1/16 0
    1/32 1/32 1/16 0
    1/32 1/32 1/16 0
]

# ---- #

const P1_ = map(sum, eachrow(JO))

@test P1_ == [1 / 2, 1 / 4, 1 / 8, 1 / 8]

# ---- #

const P2_ = map(sum, eachcol(JO))

@test P2_ == [1 / 4, 1 / 4, 1 / 4, 1 / 4]

# ---- #

const E1 = Omics.Entropy.ge(eachrow, JO)

@test E1 === 7 / 4

# ---- #

const E2 = Omics.Entropy.ge(eachcol, JO)

@test E2 === 2.0

# ---- #

const EN = sum(Omics.Entropy.ge, JO)

@test EN === 27 / 8

# ---- #

const E21 = EN - E1

@test E21 ===
      sum(pr * sum(Omics.Entropy.ge, pr_ / pr) for (pr, pr_) in zip(P1_, eachrow(JO))) ===
      13 / 8

# ---- #

const E12 = EN - E2

@test E12 ===
      sum(pr * sum(Omics.Entropy.ge, pr_ / pr) for (pr, pr_) in zip(P2_, eachcol(JO))) ===
      11 / 8

# ---- #

const MU = E1 + E2 - EN

@test MU === E1 - E12 === E2 - E21 === 3 / 8

# ---- #

for (i1_, i2_, ri, rf) in (
    ([1, 2], [1, 2], 1.0, 1.0),
    ([1, 2], [1, 3], 1.0, 1.0),
    ([1, 2, 3], [1, 1, 2], 0.9168644108463501, 0.9140184400703142),
    ([1, 2, 3], [1, 1, 3], 0.9168644108463501, 0.9140184400703134),
    ([1, 2, 3], [1, 2, 1], 0.0, 0.0),
    ([1, 2, 3], [1, 2, 2], 0.9168644108463501, 0.9140184400703132),
    ([1, 2, 3], [1, 2, 3], 1.0, 1.0),
    ([1, 2, 3], [1, 3, 1], 0.0, 0.0),
    ([1, 2, 3], [1, 3, 2], 0.9787712969683778, 0.9749301137414429),
    ([1, 2, 3], [1, 3, 3], 0.9168644108463501, 0.9140184400703134),
    ([1, 2, 1, 2], [1, 2, 1, 2], 1.0, 1.0),
    ([1, 2, 1, 2], [1, 3, 1, 3], 1.0, 1.0),
    ([1, 2, 1, 2], [1, 2, 1, 3], 0.9298734950321937, 0.9269049805641628),
    ([1, 2, 1, 2], [1, 3, 1, 2], 0.9298734950321937, 0.9269049805641628),
    ([1, 2, 1, 2], [2, 1, 2, 1], -1.0, -1.0),
    ([1, 2, 1, 2], [3, 1, 3, 1], -1.0, -1.0),
    ([1, 2, 1, 2], [2, 1, 3, 1], -0.9298734950321937, -0.9269049805641624),
    ([1, 2, 1, 2], [3, 1, 2, 1], -0.9298734950321937, -0.9269049805641624),
)

    f1_ = convert(Vector{Float64}, i1_)

    f2_ = convert(Vector{Float64}, i2_)

    @test Omics.MutualInformation.get_information_coefficient(i1_, i2_) === ri

    @test Omics.MutualInformation.get_information_coefficient(f1_, f2_) === rf

end

# ---- #

# 18.597 ns (0 allocations: 0 bytes)
# 15.782 ns (0 allocations: 0 bytes)
# 83.290 ns (4 allocations: 1.84 KiB)
# 21.666 μs (54 allocations: 43.98 KiB)
# 235.612 ns (4 allocations: 288 bytes)
# 6.142 μs (4 allocations: 640 bytes)
# 256.628 ns (0 allocations: 0 bytes)
# 5.604 μs (0 allocations: 0 bytes)
# 502.373 ns (4 allocations: 1.84 KiB)
# 27.750 μs (54 allocations: 43.98 KiB)
# 112.072 ns (0 allocations: 0 bytes)
# 49.687 ns (0 allocations: 0 bytes)
# 240.315 ns (4 allocations: 1.84 KiB)
# 26.209 μs (54 allocations: 45.52 KiB)
# 511.932 ns (4 allocations: 288 bytes)
# 6.408 μs (4 allocations: 640 bytes)
# 493.124 ns (0 allocations: 0 bytes)
# 5.861 μs (0 allocations: 0 bytes)
# 995.800 ns (4 allocations: 1.84 KiB)
# 32.500 μs (54 allocations: 45.52 KiB)
# 1.150 μs (0 allocations: 0 bytes)
# 417.920 ns (0 allocations: 0 bytes)
# 2.000 μs (4 allocations: 1.84 KiB)
# 73.292 μs (57 allocations: 59.59 KiB)
# 734.171 ns (4 allocations: 288 bytes)
# 6.392 μs (4 allocations: 640 bytes)
# 709.809 ns (0 allocations: 0 bytes)
# 5.882 μs (0 allocations: 0 bytes)
# 3.969 μs (4 allocations: 1.84 KiB)
# 80.250 μs (57 allocations: 59.59 KiB)
# 11.541 μs (0 allocations: 0 bytes)
# 4.077 μs (0 allocations: 0 bytes)
# 19.416 μs (4 allocations: 1.84 KiB)
# 982.000 μs (57 allocations: 200.09 KiB)
# 733.070 ns (4 allocations: 288 bytes)
# 6.100 μs (4 allocations: 640 bytes)
# 708.636 ns (0 allocations: 0 bytes)
# 5.653 μs (0 allocations: 0 bytes)
# 31.833 μs (4 allocations: 1.84 KiB)
# 992.041 μs (57 allocations: 200.09 KiB)
for ur in (10, 100, 1000, 10000)

    seed!(20241021)

    i1_ = rand(0:9, ur)

    i2_ = rand(0:9, ur)

    f1_ = randn(ur)

    f2_ = randn(ur)

    ci = cor(i1_, i2_)

    cf = cor(f1_, f2_)

    ji = Omics.MutualInformation._get_density(i1_, i2_, ci)

    jf = Omics.MutualInformation._get_density(f1_, f2_, cf)

    #@btime cor($i1_, $i2_)

    #@btime cor($f1_, $f2_)

    #@btime Omics.MutualInformation._get_density($i1_, $i2_, $ci)

    #@btime Omics.MutualInformation._get_density($f1_, $f2_, $cf)

    #@btime Omics.MutualInformation.get_mutual_information($ji)

    #@btime Omics.MutualInformation.get_mutual_information($jf)

    #@btime Omics.MutualInformation.get_mutual_information($ji, false)

    #@btime Omics.MutualInformation.get_mutual_information($jf, false)

    #@btime Omics.MutualInformation.get_information_coefficient($i1_, $i2_)

    #@btime Omics.MutualInformation.get_information_coefficient($f1_, $f2_)

end

# ---- #

function Omics.Entropy.ge(pr)

    iszero(pr) ? 0.0 : -pr * log(pr)

end

# ---- #

function Omics.Information.get_kullback_leibler_divergence(n1, n2)

    n1 * log(n1 / n2)

end

# ---- #

# https://cdanielaam.medium.com/how-to-compare-and-evaluate-unsupervised-clustering-methods-84f3617e3769

const RF = 1.5534700710552343

for jo in (
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

    @test Omics.MutualInformation.get_mutual_information(jo) === RF

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo, false), RF)

    @test isapprox(
        Omics.MutualInformation.get_mutual_information(jo, true),
        0.9653404496537963,
    )

end

# ---- #

# 446.487 ns (6 allocations: 1.00 KiB)
# 200.281 ns (4 allocations: 1.41 KiB)
# 208.182 ns (4 allocations: 272 bytes)
# 253.285 ns (0 allocations: 0 bytes)
# 801.022 ns (6 allocations: 1.23 KiB)
# 334.118 ns (4 allocations: 1.84 KiB)
# 483.118 ns (4 allocations: 288 bytes)
# 521.162 ns (0 allocations: 0 bytes)
# 2.741 μs (6 allocations: 1.23 KiB)
# 2.097 μs (4 allocations: 1.84 KiB)
# 661.421 ns (4 allocations: 288 bytes)
# 681.947 ns (0 allocations: 0 bytes)
# 20.208 μs (6 allocations: 1.23 KiB)
# 19.541 μs (4 allocations: 1.84 KiB)
# 619.699 ns (4 allocations: 288 bytes)
# 686.667 ns (0 allocations: 0 bytes)
for ur in (10, 100, 1000, 10000)

    seed!(20240903)

    i1_ = rand(0:9, ur)

    i2_ = rand(0:9, ur)

    rf = mutualinfo(i1_, i2_; normed = false)

    jo = Omics.Normalization.normalize_with_sum!(
        Omics.MutualInformation._get_density(i1_, i2_, NaN),
    )

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo), rf)

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo, false), rf)

    @test isapprox(
        Omics.MutualInformation.get_mutual_information(jo, true),
        mutualinfo(i1_, i2_),
    )

    #@btime mutualinfo($i1_, $i2_; normed = false)

    #@btime Omics.Normalization.normalize_with_sum!(
    #    Omics.MutualInformation._get_density($i1_, $i2_, NaN),
    #)

    #@btime Omics.MutualInformation.get_mutual_information($jo)

    #@btime Omics.MutualInformation.get_mutual_information($jo, false)

end
