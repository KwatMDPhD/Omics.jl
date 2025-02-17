using Random: seed!

using Statistics: cor

using Test: @test

using Omics

# ---- #

for (nu_, N) in (([1, 1, 2, 2], randn(1000, 4)),)

    R = Omics.Match.go(cor, nu_, N)

    @test !any(isnan, R)

    R = R[sortperm(R[:, 1]), :]

    re_ = R[:, 1]

    i1_ = findall(<(0.0), re_)

    i2_ = findall(>=(0.0), re_)

    @test issorted(R[i1_, 3])

    @test issorted(R[i1_, 4])

    @test issorted(R[i2_, 3]; rev = true)

    @test issorted(R[i2_, 4]; rev = true)

end

# ---- #

# 12.672 ms (74100 allocations: 27.24 MiB)
# 271.429 ms (740108 allocations: 271.52 MiB)
# 116.474 ms (116101 allocations: 241.47 MiB)
# 1.365 s (1160109 allocations: 2.36 GiB)

for u1 in (100, 1000), u2 in (1000, 10000)

    seed!(20250217)

    #@btime Omics.Match.go(cor, $(randn(u1)), $(randn(u2, u1)))

end
