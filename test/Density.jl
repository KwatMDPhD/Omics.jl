using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using KernelDensity: kde

using Random: seed!

# ---- #

const UG = 16

# ---- #

for nu_ in ([1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 9],)

    gr_, co_ = Omics.Density.coun(nu_, UG)

    kd = kde(nu_; boundary = extrema(nu_), npoints = UG)

    @test gr_ === kd.x

    xc_ = gr_

    tr = Dict("type" => "bar", "x" => xc_)

    la = Dict("xaxis" => Dict("tickvals" => xc_))

    Omics.Plot.plot("", (merge(tr, Dict("y" => co_)),), la)

    Omics.Plot.plot("", (merge(tr, Dict("y" => kd.density)),), la)

end

# ---- #

# 412.500 ns (2 allocations: 192 bytes)
# 3.802 μs (36 allocations: 1.89 KiB)
# 1.892 μs (2 allocations: 192 bytes)
# 5.618 μs (36 allocations: 2.66 KiB)
# 21.375 μs (2 allocations: 192 bytes)
# 25.041 μs (38 allocations: 9.70 KiB)
# 301.792 μs (2 allocations: 192 bytes)
# 419.083 μs (38 allocations: 79.95 KiB)
for ur in (10, 100, 1000, 10000)

    seed!(20241023)

    nu_ = randn(ur)

    #@btime Omics.Density.coun($nu_, UG)

    #@btime kde($nu_; boundary = $(extrema(nu_)), npoints = UG)

end

# ---- #

for (n1_, n2_) in (([1, 2, 3, 4, 6], [2, 4, 8, 16, 64]),)

    g1_, g2_, co = Omics.Density.coun(n1_, n2_, UG, UG)

    kd = kde((n1_, n2_); boundary = (extrema(n1_), extrema(n2_)), npoints = (UG, UG))

    @test g1_ == kd.x

    @test g2_ == kd.y

    l1_ = g1_

    l2_ = g2_

    Omics.Plot.plot_heat_map("", co; l1_, l2_)

    Omics.Plot.plot_heat_map("", kd.density; l1_, l2_)

end

# ---- #

# 858.194 ns (3 allocations: 2.08 KiB)
# 13.875 μs (54 allocations: 13.23 KiB)
# 3.901 μs (3 allocations: 2.08 KiB)
# 17.666 μs (54 allocations: 14.77 KiB)
# 49.708 μs (3 allocations: 2.08 KiB)
# 56.041 μs (57 allocations: 28.84 KiB)
# 623.667 μs (3 allocations: 2.08 KiB)
# 897.583 μs (57 allocations: 169.34 KiB)
for ur in (10, 100, 1000, 10000)

    seed!(20241023)

    n1_ = randn(ur)

    n2_ = randn(ur)

    #@btime Omics.Density.coun($n1_, $n2_, UG, UG)

    #@btime kde(
    #    ($n1_, $n2_);
    #    boundary = ($(extrema(n1_)), $(extrema(n2_))),
    #    npoints = (UG, UG),
    #)

end
