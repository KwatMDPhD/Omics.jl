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

# ---- #

const P1_ = Omics.MutualInformation._marginalize(eachrow, JO)

@test P1_ == [1 / 2, 1 / 4, 1 / 8, 1 / 8]

# ---- #

const P2_ = Omics.MutualInformation._marginalize(eachcol, JO)

@test P2_ == [1 / 4, 1 / 4, 1 / 4, 1 / 4]

# ---- #

const E1 = Omics.MutualInformation._marginalize_entropy_sum(eachrow, JO)

@test E1 === 7 / 4

# ---- #

const E2 = Omics.MutualInformation._marginalize_entropy_sum(eachcol, JO)

@test E2 === 2.0

# ---- #

const EJ = Omics.MutualInformation._entropy_sum(JO)

@test EJ === 27 / 8

# ---- #

const E12 = EJ - E2

@test E12 ===
      #sum(
      #    p2 * sum(Omics.MutualInformation.get_shannon_entropy, co / p2) for
      #    (p2, co) in zip(P2_, eachcol(JO))
      #) ===
      11 / 8

# ---- #

const E21 = EJ - E1

@test E21 ===
      #sum(
      #    p1 * sum(Omics.MutualInformation.get_shannon_entropy, ro / p1) for
      #    (p1, ro) in zip(P1_, eachrow(JO))
      #) ===
      13 / 8

# ---- #

const MU = E1 + E2 - EJ

@test MU === E1 - E12 === E2 - E21 === 3 / 8

# ---- #

for un in (10, 100, 1000, 10000, 100000)

    seed!(20240903)

    i1_ = rand(0:9, un)

    i2_ = rand(0:9, un)

    jo = Omics.MutualInformation._get_joint(NaN, i1_, i2_)

    @test isapprox(
        Omics.MutualInformation.get_mutual_information(jo),
        Omics.MutualInformation.get_mutual_information(jo, false),
    )

    # 419.823 ns (12 allocations: 1.50 KiB)
    # 151.380 ns (4 allocations: 224 bytes)
    # 191.693 ns (0 allocations: 0 bytes)
    # 1.483 μs (12 allocations: 2.53 KiB)
    # 523.340 ns (4 allocations: 288 bytes)
    # 548.314 ns (0 allocations: 0 bytes)
    # 13.583 μs (12 allocations: 2.53 KiB)
    # 706.851 ns (4 allocations: 288 bytes)
    # 733.008 ns (0 allocations: 0 bytes)
    # 197.750 μs (12 allocations: 2.53 KiB)
    # 678.379 ns (4 allocations: 288 bytes)
    # 737.721 ns (0 allocations: 0 bytes)
    # 2.406 ms (12 allocations: 2.53 KiB)
    # 594.039 ns (4 allocations: 288 bytes)
    # 732.558 ns (0 allocations: 0 bytes)

    @btime Omics.MutualInformation._get_joint(NaN, $i1_, $i2_)

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

    # 11.041 ns (0 allocations: 0 bytes)
    # 10.511 ns (0 allocations: 0 bytes)
    # 10.927 ns (0 allocations: 0 bytes)
    # 10.511 ns (0 allocations: 0 bytes)
    # 444.589 ns (16 allocations: 1.09 KiB)
    # 27.375 μs (58 allocations: 44.48 KiB)
    # 461.294 ns (16 allocations: 1.09 KiB)
    # 27.375 μs (58 allocations: 44.48 KiB)
    # 462.390 ns (16 allocations: 1.09 KiB)
    # 29.792 μs (58 allocations: 44.48 KiB)
    # 458.546 ns (16 allocations: 1.09 KiB)
    # 27.333 μs (58 allocations: 44.48 KiB)
    # 12.012 ns (0 allocations: 0 bytes)
    # 11.678 ns (0 allocations: 0 bytes)
    # 459.405 ns (16 allocations: 1.09 KiB)
    # 29.875 μs (58 allocations: 44.48 KiB)
    # 459.391 ns (16 allocations: 1.12 KiB)
    # 29.583 μs (58 allocations: 44.48 KiB)
    # 471.301 ns (16 allocations: 1.09 KiB)
    # 27.417 μs (58 allocations: 44.48 KiB)
    # 13.263 ns (0 allocations: 0 bytes)
    # 12.763 ns (0 allocations: 0 bytes)
    # 13.179 ns (0 allocations: 0 bytes)
    # 12.679 ns (0 allocations: 0 bytes)
    # 475.765 ns (16 allocations: 1.09 KiB)
    # 26.959 μs (58 allocations: 44.52 KiB)
    # 494.845 ns (16 allocations: 1.09 KiB)
    # 26.958 μs (58 allocations: 44.52 KiB)
    # 13.263 ns (0 allocations: 0 bytes)
    # 12.721 ns (0 allocations: 0 bytes)
    # 13.179 ns (0 allocations: 0 bytes)
    # 12.804 ns (0 allocations: 0 bytes)
    # 475.641 ns (16 allocations: 1.09 KiB)
    # 27.042 μs (58 allocations: 44.52 KiB)
    # 478.309 ns (16 allocations: 1.09 KiB)
    # 27.000 μs (58 allocations: 44.52 KiB)

    @btime Omics.MutualInformation.get_information_coefficient($i1_, $i2_)

    @btime Omics.MutualInformation.get_information_coefficient($f1_, $f2_)

end

# ---- #

# https://cdanielaam.medium.com/how-to-compare-and-evaluate-unsupervised-clustering-methods-84f3617e3769
for (jo, rp, re) in (
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

    @test Omics.MutualInformation.get_mutual_information(jo) === rp

    @info Omics.MutualInformation.get_mutual_information(jo, false)

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo, true), re)

    # 151.944 ns (4 allocations: 192 bytes)
    # 156.406 ns (0 allocations: 0 bytes)
    # 152.301 ns (4 allocations: 192 bytes)
    # 156.666 ns (0 allocations: 0 bytes)

    @btime Omics.MutualInformation.get_mutual_information($jo)

    @btime Omics.MutualInformation.get_mutual_information($jo, true)

end

# ---- #

for un in (10, 100, 1000, 10000, 100000)

    seed!(20240903)

    i1_ = rand(0:9, un)

    i2_ = rand(0:9, un)

    fa = mutualinfo(i1_, i2_; normed = false)

    jo = Omics.MutualInformation._get_joint(NaN, i1_, i2_)

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo), fa)

    @test isapprox(Omics.MutualInformation.get_mutual_information(jo, false), fa)

    @test isapprox(
        Omics.MutualInformation.get_mutual_information(jo, true),
        mutualinfo(i1_, i2_),
    )

    # 512.220 ns (6 allocations: 1.00 KiB)
    # 471.515 ns (12 allocations: 1.50 KiB)
    # 193.556 ns (4 allocations: 224 bytes)
    # 198.052 ns (0 allocations: 0 bytes)
    # 842.391 ns (6 allocations: 1.23 KiB)
    # 1.567 μs (12 allocations: 2.53 KiB)
    # 525.571 ns (4 allocations: 288 bytes)
    # 531.137 ns (0 allocations: 0 bytes)
    # 2.787 μs (6 allocations: 1.23 KiB)
    # 15.875 μs (12 allocations: 2.53 KiB)
    # 714.072 ns (4 allocations: 288 bytes)
    # 696.791 ns (0 allocations: 0 bytes)
    # 20.250 μs (6 allocations: 1.23 KiB)
    # 197.667 μs (12 allocations: 2.53 KiB)
    # 662.929 ns (4 allocations: 288 bytes)
    # 697.199 ns (0 allocations: 0 bytes)
    # 193.916 μs (6 allocations: 1.23 KiB)
    # 2.408 ms (12 allocations: 2.53 KiB)
    # 583.790 ns (4 allocations: 288 bytes)
    # 696.143 ns (0 allocations: 0 bytes)

    @btime mutualinfo($i1_, $i2_; normed = false)

    @btime Omics.MutualInformation._get_joint(NaN, $i1_, $i2_)

    @btime Omics.MutualInformation.get_mutual_information($jo)

    @btime Omics.MutualInformation.get_mutual_information($jo, false)

end
