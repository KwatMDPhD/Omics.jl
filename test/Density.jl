using Test: @test

using Nucleus

# ---- #

for po in 0:7

    nu_ = randn(10^po)

    # TODO: Test.
    @info Nucleus.Density.get_bandwidth(nu_)

    # 3.333 ns (0 allocations: 0 bytes)
    # 143.765 ns (3 allocations: 304 bytes)
    # 657.920 ns (3 allocations: 1.03 KiB)
    # 6.592 μs (3 allocations: 8.09 KiB)
    # 253.042 μs (4 allocations: 78.33 KiB)
    # 3.843 ms (4 allocations: 781.45 KiB)
    # 43.703 ms (4 allocations: 7.63 MiB)
    # 510.049 ms (4 allocations: 76.29 MiB)
    #@btime Nucleus.Density.get_bandwidth($nu_)

end

# ---- #

const NU_ = [1, 2, 3, 4, 5, 6]

# ---- #

for (nu1_, nu2_) in (
    (NU_, NU_),
    (NU_, [2^po for po in NU_]),
    (NU_, NU_[end:-1:1]),
    (NU_, [2^po for po in NU_[end:-1:1]]),
)

    ro_, co_, de = Nucleus.Density.estimate((nu1_, nu2_); npoints = (8, 16))

    # TODO: Test.
    # TODO: Benchmark.

    Nucleus.Density.plot("", ro_, co_, de; title_text = join(zip(nu1_, nu2_), " "))

end
