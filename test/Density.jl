using KernelDensity: kde

using Random: seed!

using Test: @test

using Omics

# ---- #

const UM = 16

# ---- #

for nu_ in ([1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 9],)

    gr_, um_ = Omics.Density.coun(nu_, UM)

    kd = kde(nu_; boundary = extrema(nu_), npoints = UM)

    @test gr_ === kd.x

    tr = Dict("type" => "bar", "x" => gr_)

    la = Dict("xaxis" => Dict("tickvals" => gr_))

    Omics.Plot.plot("", (merge(tr, Dict("y" => um_)),), la)

    Omics.Plot.plot("", (merge(tr, Dict("y" => kd.density)),), la)

end

# ---- #

# 21.250 μs (2 allocations: 192 bytes)
# 25.166 μs (38 allocations: 9.70 KiB)

for um in (1000, 10000)

    seed!(20241023)

    nu_ = randn(um)

    #@btime Omics.Density.coun($nu_, UM)

    #@btime kde($nu_; boundary = $(extrema(nu_)), npoints = UM)

end

# ---- #

for (n1_, n2_) in (([1, 2, 3, 4, 6], [2, 4, 8, 16, 64]),)

    g1_, g2_, um = Omics.Density.coun(n1_, n2_, UM, UM)

    kd = kde((n1_, n2_); boundary = (extrema(n1_), extrema(n2_)), npoints = (UM, UM))

    @test g1_ === kd.x

    @test g2_ === kd.y

    yc_ = g1_

    xc_ = g2_

    Omics.Plot.plot_heat_map("", um; yc_, xc_)

    Omics.Plot.plot_heat_map("", kd.density; yc_, xc_)

end

# ---- #

# 40.750 μs (3 allocations: 2.08 KiB)
# 56.167 μs (57 allocations: 28.84 KiB)

for um in (1000, 10000)

    seed!(20241023)

    n1_ = randn(um)

    n2_ = randn(um)

    #@btime Omics.Density.coun($n1_, $n2_, UM, UM)

    #@btime kde(
    #    ($n1_, $n2_);
    #    boundary = ($(extrema(n1_)), $(extrema(n2_))),
    #    npoints = (UM, UM),
    #)

end
