using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using KernelDensity: kde

using Random: seed!

# ---- #

for (nu_, ug, re) in (
    ([0, 1], 2, 0.0:1:1),
    ([0, 1], 3, 0.0:0.5:1),
    ([-1, 1], 2, -1.0:2:1),
    ([-1, 1], 3, -1.0:1:1),
)

    @test Omics.Density.grid(nu_, ug) === re

    # 50.025 ns (0 allocations: 0 bytes)
    # 49.983 ns (0 allocations: 0 bytes)
    # 50.016 ns (0 allocations: 0 bytes)
    # 49.992 ns (0 allocations: 0 bytes)
    #@btime Omics.Density.grid($nu_, $ug)

end

# ---- #

for (gr_, nu, re) in (
    ([-2, -1, 0, 1, 2], -3, 1),
    ([-2, -1, 0, 1, 2], -2, 1),
    ([-2, -1, 0, 1, 2], -1, 2),
    ([-2, -1, 0, 1, 2], 0, 3),
    ([-2, -1, 0, 1, 2], 1, 4),
    ([-2, -1, 0, 1, 2], 2, 5),
    ([-2, -1, 0, 1, 2], 3, 5),
)

    @test Omics.Density._find(gr_, nu) === re

    # 2.708 ns (0 allocations: 0 bytes)
    # 2.709 ns (0 allocations: 0 bytes)
    # 2.708 ns (0 allocations: 0 bytes)
    # 3.000 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.916 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    #@btime Omics.Density._find($gr_, $nu)

end

# ---- #

const UG = 8

# ---- #

seed!(20240830)

const N1_ = randn(100)

# ---- #

kd = kde(N1_; npoints = UG)

Omics.Plot.plot(
    "",
    (Dict("type" => "bar", "y" => kd.density, "x" => kd.x),),
    Dict("title" => Dict("text" => "KDE")),
)

# ---- #

g1_, de = Omics.Density.coun(N1_, UG)

Omics.Plot.plot(
    "",
    (Dict("type" => "bar", "y" => de, "x" => g1_),),
    Dict("title" => Dict("text" => "Count")),
)

# ---- #

for up in (10, 100, 1000, 10000, 100000)

    seed!(20240831)

    n1_ = rand(up)

    # 3.818 μs (36 allocations: 1.70 KiB)
    # 365.784 ns (2 allocations: 128 bytes)
    # 6.017 μs (36 allocations: 2.47 KiB)
    # 1.358 μs (2 allocations: 128 bytes)
    # 29.708 μs (38 allocations: 9.52 KiB)
    # 11.041 μs (2 allocations: 128 bytes)
    # 467.458 μs (38 allocations: 79.77 KiB)
    # 224.125 μs (2 allocations: 128 bytes)
    # 5.578 ms (38 allocations: 782.89 KiB)
    # 2.593 ms (2 allocations: 128 bytes)

    #@btime kde($n1_; npoints = UG)

    #@btime Omics.Density.coun($n1_, UG)

end

# ---- #

seed!(20240831)

const N2_ = randn(100)

# ---- #

kd = kde((N1_, N2_); npoints = (UG, UG))

Omics.Plot.plot_heat_map(
    "",
    kd.density;
    ro_ = kd.y,
    co_ = kd.x,
    la = Dict("title" => Dict("text" => "KDE")),
)

# ---- #

g1_, g2_, de = Omics.Density.coun(N1_, N2_, UG)

Omics.Plot.plot_heat_map(
    "",
    de;
    ro_ = g1_,
    co_ = g2_,
    rg_ = Omics.Palette.bwr,
    la = Dict("title" => Dict("text" => "Count")),
)

# ---- #

for up in (10, 100, 1000, 10000, 100000)

    seed!(20240831)

    n1_ = rand(up)

    n2_ = rand(up)

    # 11.875 μs (49 allocations: 5.36 KiB)
    # 769.287 ns (2 allocations: 592 bytes)
    # 16.333 μs (49 allocations: 6.89 KiB)
    # 2.616 μs (2 allocations: 592 bytes)
    # 63.875 μs (52 allocations: 20.97 KiB)
    # 22.291 μs (2 allocations: 592 bytes)
    # 1.018 ms (52 allocations: 161.47 KiB)
    # 482.792 μs (2 allocations: 592 bytes)
    # 11.463 ms (52 allocations: 1.53 MiB)
    # 5.141 ms (2 allocations: 592 bytes)

    #@btime kde(($n1_, $n2_); npoints = (UG, UG))

    #@btime Omics.Density.coun($n1_, $n2_, UG)

end

# ---- #

for (a1_, a2_, re) in (
    (
        [-2, 0, 2, 4],
        [-1, 1, 3, 5],
        [
            1 0 0 0
            0 1 0 0
            0 0 1 0
            0 0 0 1
        ],
    ),
    (
        [-2, 2, 4, 0],
        [-1, 3, 5, 1],
        [
            1 0 0 0
            0 1 0 0
            0 0 1 0
            0 0 0 1
        ],
    ),
)

    @test Omics.Density.coun(a1_, a2_) == re

    # 203.205 ns (10 allocations: 912 bytes)
    # 235.596 ns (10 allocations: 912 bytes)
    #@btime Omics.Density.coun($a1_, $a2_)

end
