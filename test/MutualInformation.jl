using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Clustering: mutualinfo

using Random: seed!

# ---- #

const JO = [
    1/8 1/16 1/16 1/4
    1/16 1/8 1/16 0
    1/32 1/32 1/16 0
    1/32 1/32 1/16 0
]

const P1_ = Omics.Probability.ge(eachrow, JO)

const P2_ = Omics.Probability.ge(eachcol, JO)

const E1 = Omics.Entropy.ge(eachrow, JO)

const E2 = Omics.Entropy.ge(eachcol, JO)

const EN = Omics.Entropy.ge(JO)

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

for uz in 1:5

    seed!(20240903)

    un = 10^uz

    i1_ = rand(0:9, un)

    i2_ = rand(0:9, un)

    jo = Omics.Probability.ge(NaN, i1_, i2_)

    @test isapprox(
        Omics.MutualInformation.get_mutual_information(jo),
        Omics.MutualInformation.get_mutual_information(jo, false),
    )

    # 151.742 ns (4 allocations: 224 bytes)
    # 190.925 ns (0 allocations: 0 bytes)
    # 520.288 ns (4 allocations: 288 bytes)
    # 548.348 ns (0 allocations: 0 bytes)
    # 725.266 ns (4 allocations: 288 bytes)
    # 737.908 ns (0 allocations: 0 bytes)
    # 678.134 ns (4 allocations: 288 bytes)
    # 732.369 ns (0 allocations: 0 bytes)
    # 608.000 ns (4 allocations: 288 bytes)
    # 733.654 ns (0 allocations: 0 bytes)

    @btime Omics.MutualInformation.get_mutual_information($jo)

    @btime Omics.MutualInformation.get_mutual_information($jo, false)

end

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

    # 10.928 ns (0 allocations: 0 bytes)
    # 10.552 ns (0 allocations: 0 bytes)
    # 10.969 ns (0 allocations: 0 bytes)
    # 10.594 ns (0 allocations: 0 bytes)
    # 413.540 ns (16 allocations: 1.09 KiB)
    # 27.666 μs (58 allocations: 44.48 KiB)
    # 399.080 ns (16 allocations: 1.09 KiB)
    # 27.541 μs (58 allocations: 44.48 KiB)
    # 418.342 ns (16 allocations: 1.09 KiB)
    # 29.959 μs (58 allocations: 44.48 KiB)
    # 418.764 ns (16 allocations: 1.09 KiB)
    # 27.583 μs (58 allocations: 44.48 KiB)
    # 12.095 ns (0 allocations: 0 bytes)
    # 11.637 ns (0 allocations: 0 bytes)
    # 419.392 ns (16 allocations: 1.09 KiB)
    # 30.083 μs (58 allocations: 44.48 KiB)
    # 413.540 ns (16 allocations: 1.12 KiB)
    # 30.000 μs (58 allocations: 44.48 KiB)
    # 420.015 ns (16 allocations: 1.09 KiB)
    # 27.625 μs (58 allocations: 44.48 KiB)
    # 13.179 ns (0 allocations: 0 bytes)
    # 12.679 ns (0 allocations: 0 bytes)
    # 13.221 ns (0 allocations: 0 bytes)
    # 12.721 ns (0 allocations: 0 bytes)
    # 446.701 ns (16 allocations: 1.09 KiB)
    # 27.292 μs (58 allocations: 44.52 KiB)
    # 434.975 ns (16 allocations: 1.09 KiB)
    # 27.292 μs (58 allocations: 44.52 KiB)
    # 13.304 ns (0 allocations: 0 bytes)
    # 12.680 ns (0 allocations: 0 bytes)
    # 13.180 ns (0 allocations: 0 bytes)
    # 12.888 ns (0 allocations: 0 bytes)
    # 444.589 ns (16 allocations: 1.09 KiB)
    # 27.292 μs (58 allocations: 44.52 KiB)
    # 439.606 ns (16 allocations: 1.09 KiB)
    # 27.709 μs (58 allocations: 44.52 KiB)

    @btime Omics.MutualInformation.get_information_coefficient($i1_, $i2_)

    @btime Omics.MutualInformation.get_information_coefficient($f1_, $f2_)

end

# ---- #

function Omics.Entropy.ge(pr::Real)

    -pr * log(pr)

end

function Omics.Information.get_kullback_leibler_divergence(n1, n2)

    n1 * log(n1 / n2)

end

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

    @test Omics.MutualInformation.get_mutual_information(jo) === rf

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo, false), rf)

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo, true), rt)

    # 120.894 ns (4 allocations: 192 bytes)
    # 136.671 ns (0 allocations: 0 bytes)
    # 120.765 ns (4 allocations: 192 bytes)
    # 136.332 ns (0 allocations: 0 bytes)

    @btime Omics.MutualInformation.get_mutual_information($jo)

    @btime Omics.MutualInformation.get_mutual_information($jo, true)

end

# ---- #

for uz in 1:5

    seed!(20240903)

    un = 10^uz

    i1_ = rand(0:9, un)

    i2_ = rand(0:9, un)

    rf = mutualinfo(i1_, i2_; normed = false)

    jo = Omics.Probability.ge(NaN, i1_, i2_)

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo), rf)

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo, false), rf)

    @test isapprox(
        Omics.MutualInformation.get_mutual_information(jo, true),
        mutualinfo(i1_, i2_),
    )

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

    @btime Omics.Probability.ge(NaN, $i1_, $i2_)

    @btime Omics.MutualInformation.get_mutual_information($jo)

    @btime Omics.MutualInformation.get_mutual_information($jo, false)

end
