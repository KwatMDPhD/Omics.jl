using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Clustering: mutualinfo

using Random: seed!

# ---- #

for (i1_, i2_, ri, rf) in (
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

    @test isapprox(Omics.MutualInformation.get_information_coefficient(i1_, i2_), ri)

    @test isapprox(Omics.MutualInformation.get_information_coefficient(f1_, f2_), rf)

    # 11.136 ns (0 allocations: 0 bytes)
    # 10.636 ns (0 allocations: 0 bytes)
    # 11.261 ns (0 allocations: 0 bytes)
    # 10.666 ns (0 allocations: 0 bytes)
    # 576.850 ns (40 allocations: 2.00 KiB)
    # 26.792 μs (58 allocations: 44.48 KiB)
    # 588.856 ns (40 allocations: 2.00 KiB)
    # 26.625 μs (58 allocations: 44.48 KiB)
    # 571.429 ns (40 allocations: 2.00 KiB)
    # 29.250 μs (58 allocations: 44.48 KiB)
    # 567.623 ns (40 allocations: 2.00 KiB)
    # 26.667 μs (58 allocations: 44.48 KiB)
    # 12.262 ns (0 allocations: 0 bytes)
    # 11.679 ns (0 allocations: 0 bytes)
    # 574.257 ns (40 allocations: 2.00 KiB)
    # 29.250 μs (58 allocations: 44.48 KiB)
    # 569.293 ns (40 allocations: 2.05 KiB)
    # 29.042 μs (58 allocations: 44.48 KiB)
    # 605.769 ns (40 allocations: 2.00 KiB)
    # 26.750 μs (58 allocations: 44.48 KiB)
    # 13.346 ns (0 allocations: 0 bytes)
    # 12.763 ns (0 allocations: 0 bytes)
    # 13.263 ns (0 allocations: 0 bytes)
    # 12.763 ns (0 allocations: 0 bytes)
    # 581.717 ns (40 allocations: 2.00 KiB)
    # 26.375 μs (58 allocations: 44.52 KiB)
    # 582.873 ns (40 allocations: 2.00 KiB)
    # 26.459 μs (58 allocations: 44.52 KiB)
    # 13.346 ns (0 allocations: 0 bytes)
    # 12.763 ns (0 allocations: 0 bytes)
    # 13.263 ns (0 allocations: 0 bytes)
    # 12.763 ns (0 allocations: 0 bytes)
    # 579.167 ns (40 allocations: 2.00 KiB)
    # 26.458 μs (58 allocations: 44.52 KiB)
    # 579.633 ns (40 allocations: 2.00 KiB)
    # 26.500 μs (58 allocations: 44.52 KiB)

    @btime Omics.MutualInformation.get_information_coefficient($i1_, $i2_)

    @btime Omics.MutualInformation.get_information_coefficient($f1_, $f2_)

end

# ---- #

const JO = [
    1/8 1/16 1/16 1/4
    1/16 1/8 1/16 0
    1/32 1/32 1/16 0
    1/32 1/32 1/16 0
]

const P1_ = Omics.Probability.ge(eachrow, JO)

@test P1_ == [1 / 2, 1 / 4, 1 / 8, 1 / 8]

const P2_ = Omics.Probability.ge(eachcol, JO)

@test P2_ == [1 / 4, 1 / 4, 1 / 4, 1 / 4]

const E1 = Omics.Entropy.ge(eachrow, JO)

@test E1 === 7 / 4

const E2 = Omics.Entropy.ge(eachcol, JO)

@test E2 === 2.0

const EN = Omics.Entropy.ge(JO)

@test EN === 27 / 8

const E12 = EN - E2

@test E12 ===
      sum(pr * Omics.Entropy.ge(pr_ / pr) for (pr, pr_) in zip(P2_, eachcol(JO))) ===
      11 / 8

const E21 = EN - E1

@test E21 ===
      sum(pr * Omics.Entropy.ge(pr_ / pr) for (pr, pr_) in zip(P1_, eachrow(JO))) ===
      13 / 8

const MU = E1 + E2 - EN

@test MU === E1 - E12 === E2 - E21 === 3 / 8

# ---- #

function Omics.Entropy.ge(pr::Real)

    -pr * log(pr)

end

function Omics.Information.get_kullback_leibler_divergence(n1, n2)

    n1 * log(n1 / n2)

end

# ---- #

# https://cdanielaam.medium.com/how-to-compare-and-evaluate-unsupervised-clustering-methods-84f3617e3769

const RF = 1.5534700710552343

const RT = 0.9653404496537963

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

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo, true), RT)

end

# ---- #

for ur in (10, 100, 1000, 10000)

    seed!(20240903)

    i1_ = rand(0:9, ur)

    i2_ = rand(0:9, ur)

    rf = mutualinfo(i1_, i2_; normed = false)

    rt = mutualinfo(i1_, i2_)

    jo = Omics.Normalization.normalize_with_sum!(
        convert(
            Matrix{Float64},
            Omics.Density.coun(i1_, i2_, (Omics.Dic.index(i1_), Omics.Dic.index(i2_)))[3],
        ),
    )

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo), rf)

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo, false), rf)

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo, true), rt)

    # 432.869 ns (6 allocations: 1.00 KiB)
    # 435.914 ns (12 allocations: 1.50 KiB)
    # 150.909 ns (4 allocations: 224 bytes)
    # 181.655 ns (0 allocations: 0 bytes)
    # 778.698 ns (6 allocations: 1.23 KiB)
    # 1.562 μs (12 allocations: 2.53 KiB)
    # 484.831 ns (4 allocations: 288 bytes)
    # 515.406 ns (0 allocations: 0 bytes)
    # 2.718 μs (6 allocations: 1.23 KiB)
    # 15.625 μs (12 allocations: 2.53 KiB)
    # 661.975 ns (4 allocations: 288 bytes)
    # 689.167 ns (0 allocations: 0 bytes)
    # 20.167 μs (6 allocations: 1.23 KiB)
    # 197.708 μs (12 allocations: 2.53 KiB)
    # 619.152 ns (4 allocations: 288 bytes)
    # 685.430 ns (0 allocations: 0 bytes)
    # 193.833 μs (6 allocations: 1.23 KiB)
    # 2.414 ms (12 allocations: 2.53 KiB)
    # 548.572 ns (4 allocations: 288 bytes)
    # 686.947 ns (0 allocations: 0 bytes)

    @btime mutualinfo($i1_, $i2_; normed = false)

    @btime Omics.Normalization.normalize_with_sum!(
        convert(
            Matrix{Float64},
            Omics.Density.coun($i1_, $i2_, (Omics.Dic.index($i1_), Omics.Dic.index($i2_)))[3],
        ),
    )

    @btime Omics.MutualInformation.get_mutual_information($jo)

    @btime Omics.MutualInformation.get_mutual_information($jo, false)

end
