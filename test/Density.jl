using KernelDensity: kde

using Random: seed!

using Test: @test

using Omics

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
# 4.173 μs (36 allocations: 1.89 KiB)
# 1.887 μs (2 allocations: 192 bytes)
# 6.058 μs (36 allocations: 2.66 KiB)
# 20.250 μs (2 allocations: 192 bytes)
# 25.500 μs (38 allocations: 9.70 KiB)
# 307.458 μs (2 allocations: 192 bytes)
# 417.041 μs (38 allocations: 79.95 KiB)
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

    ro_ = g1_

    co_ = g2_

    Omics.Plot.plot_heat_map("", co; ro_, co_)

    Omics.Plot.plot_heat_map("", kd.density; ro_, co_)

end

# ---- #

# 858.194 ns (3 allocations: 2.08 KiB)
# 15.083 μs (54 allocations: 13.23 KiB)
# 3.906 μs (3 allocations: 2.08 KiB)
# 18.791 μs (54 allocations: 14.77 KiB)
# 42.334 μs (3 allocations: 2.08 KiB)
# 56.959 μs (57 allocations: 28.84 KiB)
# 624.291 μs (3 allocations: 2.08 KiB)
# 901.042 μs (57 allocations: 169.34 KiB)
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
