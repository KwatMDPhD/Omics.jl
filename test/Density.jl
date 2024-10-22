using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using KernelDensity: kde

using Random: seed!

# ---- #

for (nu_, ug, re) in (([-1, 1], 2, -1.0:2:1), ([1, -1], 3, -1.0:1:1))

    @test Omics.Density.grid(nu_, ug) === re

    # 50.016 ns (0 allocations: 0 bytes)
    # 49.992 ns (0 allocations: 0 bytes)
    #@btime Omics.Density.grid($nu_, $ug)

end

# ---- #

const GR_ = [-4, -2, -1, 0, 1, 2, 4]

for (nu, re) in (
    (-5, 1),
    (-4, 1),
    (-3, 2),
    (-2, 2),
    (-1, 3),
    (0, 4),
    (1, 5),
    (2, 6),
    (3, 7),
    (4, 7),
    (5, 7),
)

    @test Omics.Density.find(GR_, nu) === re

    # 2.416 ns (0 allocations: 0 bytes)
    # 2.375 ns (0 allocations: 0 bytes)
    # 3.000 ns (0 allocations: 0 bytes)
    # 3.000 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 4.250 ns (0 allocations: 0 bytes)
    # 4.583 ns (0 allocations: 0 bytes)
    # 4.875 ns (0 allocations: 0 bytes)
    # 5.208 ns (0 allocations: 0 bytes)
    # 5.167 ns (0 allocations: 0 bytes)
    # 5.500 ns (0 allocations: 0 bytes)
    #@btime Omics.Density.find(GR_, $nu)

end

# ---- #

const UG = 16

# ---- #

for nu_ in ([1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 9],)

    gr_, co_ = Omics.Density.coun(nu_, UG)

    kd = kde(nu_; boundary = extrema(nu_), npoints = UG)

    @test gr_ === kd.x

    Omics.Plot.plot(
        "",
        (Dict("type" => "bar", "y" => co_, "x" => gr_),),
        Dict("xaxis" => Dict("tickvals" => gr_)),
    )

    Omics.Plot.plot(
        "",
        (Dict("type" => "bar", "y" => kd.density, "x" => kd.x),),
        Dict("xaxis" => Dict("tickvals" => kd.x)),
    )

end

# ---- #

for ur in (10, 100, 1000, 10000)

    seed!(20240831)

    nu_ = rand(ur)

    # 407.080 ns (2 allocations: 192 bytes)
    # 3.982 μs (36 allocations: 1.89 KiB)
    # 1.854 μs (2 allocations: 192 bytes)
    # 5.854 μs (36 allocations: 2.66 KiB)
    # 16.500 μs (2 allocations: 192 bytes)
    # 24.875 μs (38 allocations: 9.70 KiB)
    # 302.000 μs (2 allocations: 192 bytes)
    # 414.125 μs (38 allocations: 79.95 KiB)

    #@btime Omics.Density.coun($nu_, UG)

    #@btime kde($nu_; boundary = $(extrema(nu_)), npoints = UG)

end

# ---- #

for (n1_, n2_) in (([1, 2, 3, 4, 6], [2, 4, 8, 16, 64]),)

    g1_, g2_, co = Omics.Density.coun(n1_, n2_, UG, UG)

    kd = kde((n1_, n2_); boundary = (extrema(n1_), extrema(n2_)), npoints = (UG, UG))

    @test g1_ == kd.x

    @test g2_ == kd.y

    Omics.Plot.plot_heat_map("", co; ro_ = g1_, co_ = g2_)

    Omics.Plot.plot_heat_map("", kd.density; ro_ = kd.x, co_ = kd.y)

end

# ---- #

for ur in (10, 100, 1000, 10000)

    seed!(20240831)

    n1_ = rand(ur)

    n2_ = rand(ur)

    # 927.094 ns (3 allocations: 2.08 KiB)
    # 13.916 μs (54 allocations: 13.23 KiB)
    # 3.635 μs (3 allocations: 2.08 KiB)
    # 17.500 μs (54 allocations: 14.77 KiB)
    # 35.208 μs (3 allocations: 2.08 KiB)
    # 55.792 μs (57 allocations: 28.84 KiB)
    # 627.667 μs (3 allocations: 2.08 KiB)
    # 914.083 μs (57 allocations: 169.34 KiB)

    #@btime Omics.Density.coun($n1_, $n2_, UG, UG)

    #@btime kde(
    #    ($n1_, $n2_);
    #    boundary = ($(extrema(n1_)), $(extrema(n2_))),
    #    npoints = (UG, UG),
    #)

end
