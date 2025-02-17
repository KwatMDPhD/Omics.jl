using Random: randstring, seed!

using StatsBase: mean

using Test: @test

using Omics

# ---- #

const N1 = [
    1 2
    10 20
    100 200
]

for (f1_, re) in (
    (["R1", "R1", "R2"], (
        ["R1", "R2"],
        [
            5.5 11
            100 200
        ],
    )),
    (["R1", "R1", "R1"], (["R1"], [37.0 74])),
)

    @test Omics.XSampleFeature.collapse(mean, Float64, f1_, N1) == re

end

# ---- #

# 26.500 μs (478 allocations: 187.80 KiB)

for ur in (1000, 10000)

    seed!(20230920)

    #@btime Omics.XSampleFeature.collapse(
    #    mean,
    #    Float64,
    #    $(map(_ -> randstring('A':'G', 3), 1:ur)),
    #    $(rand(ur, ur)),
    #)

end

# ---- #

Omics.XSampleFeature.process

# ---- #

Omics.XSampleFeature.writ
