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
    # 3.797 μs (36 allocations: 1.89 KiB)
    # 1.858 μs (2 allocations: 192 bytes)
    # 5.632 μs (36 allocations: 2.66 KiB)
    # 17.625 μs (2 allocations: 192 bytes)
    # 24.667 μs (38 allocations: 9.70 KiB)
    # 304.625 μs (2 allocations: 192 bytes)
    # 415.542 μs (38 allocations: 79.95 KiB)

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

    # 954.545 ns (3 allocations: 2.08 KiB)
    # 14.125 μs (54 allocations: 13.23 KiB)
    # 3.656 μs (3 allocations: 2.08 KiB)
    # 17.584 μs (54 allocations: 14.77 KiB)
    # 43.041 μs (3 allocations: 2.08 KiB)
    # 56.041 μs (57 allocations: 28.84 KiB)
    # 624.958 μs (3 allocations: 2.08 KiB)
    # 914.458 μs (57 allocations: 169.34 KiB)

    #@btime Omics.Density.coun($n1_, $n2_, UG, UG)

    #@btime kde(
    #    ($n1_, $n2_);
    #    boundary = ($(extrema(n1_)), $(extrema(n2_))),
    #    npoints = (UG, UG),
    #)

end
