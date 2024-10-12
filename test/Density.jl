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

    # 51.587 ns (0 allocations: 0 bytes)
    # 51.597 ns (0 allocations: 0 bytes)
    # 51.588 ns (0 allocations: 0 bytes)
    # 51.724 ns (0 allocations: 0 bytes)
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

    @test Omics.Density.find(gr_, nu) === re

    # 4.291 ns (0 allocations: 0 bytes)
    # 4.250 ns (0 allocations: 0 bytes)
    # 4.291 ns (0 allocations: 0 bytes)
    # 4.291 ns (0 allocations: 0 bytes)
    # 4.291 ns (0 allocations: 0 bytes)
    # 4.291 ns (0 allocations: 0 bytes)
    # 4.250 ns (0 allocations: 0 bytes)
    #@btime Omics.Density.find($gr_, $nu)

end

# ---- #

const UG = 8

# ---- #

seed!(20240830)

const N1_ = randn(100)

# ---- #

kd = kde(N1_; npoints = UG)

# 6.267 μs (24 allocations: 2.50 KiB)
#@btime kde(N1_; npoints = UG);

Omics.Plot.plot(
    "",
    (Dict("type" => "bar", "y" => kd.density, "x" => kd.x),),
    Dict(
        "title" => Dict("text" => "KDE"),
        "yaxis" => Dict("title" => Dict("text" => "Count")),
    ),
)

# ---- #

g1_, co = Omics.Density.coun(N1_, UG)

# 3.474 μs (1 allocation: 128 bytes)
#@btime Omics.Density.coun(N1_, UG);

Omics.Plot.plot(
    "",
    (Dict("type" => "bar", "y" => co, "x" => g1_),),
    Dict(
        "title" => Dict("text" => "Count"),
        "yaxis" => Dict("title" => Dict("text" => "Count")),
    ),
)

# ---- #

for up in (10, 100, 1000, 10000, 100000)

    seed!(20240831)

    n1_ = rand(up)

    # 3.958 μs (24 allocations: 1.77 KiB)
    # 495.062 ns (1 allocation: 128 bytes)
    # 6.175 μs (24 allocations: 2.50 KiB)
    # 3.531 μs (1 allocation: 128 bytes)
    # 30.083 μs (25 allocations: 9.64 KiB)
    # 39.584 μs (1 allocation: 128 bytes)
    # 470.417 μs (26 allocations: 79.81 KiB)
    # 410.500 μs (1 allocation: 128 bytes)
    # 5.586 ms (26 allocations: 782.94 KiB)
    # 4.111 ms (1 allocation: 128 bytes)

    #@btime kde($n1_; npoints = UG)

    #@btime Omics.Density.coun($n1_, UG)

end

# ---- #

seed!(20240831)

const N2_ = randn(100)

# ---- #

kd = kde((N1_, N2_); npoints = (UG, UG))

# 16.500 μs (33 allocations: 6.95 KiB)
#@btime kde((N1_, N2_); npoints = (UG, UG));

Omics.Plot.plot_heat_map(
    "",
    kd.density;
    ro_ = kd.y,
    co_ = kd.x,
    la = Dict("title" => Dict("text" => "KDE")),
)

# ---- #

g1_, g2_, co = Omics.Density.coun(N1_, N2_, UG)

# 7.125 μs (1 allocation: 576 bytes)
#@btime Omics.Density.coun(N1_, N2_, UG);

Omics.Plot.plot_heat_map(
    "",
    co;
    ro_ = g1_,
    co_ = g2_,
    la = Dict("title" => Dict("text" => "Count")),
)

# ---- #

for up in (10, 100, 1000, 10000, 100000)

    seed!(20240831)

    n1_ = rand(up)

    n2_ = rand(up)

    # 12.000 μs (33 allocations: 5.48 KiB)
    # 1.000 μs (1 allocation: 576 bytes)
    # 16.583 μs (33 allocations: 6.95 KiB)
    # 6.758 μs (1 allocation: 576 bytes)
    # 65.291 μs (34 allocations: 21.22 KiB)
    # 80.375 μs (1 allocation: 576 bytes)
    # 1.025 ms (36 allocations: 161.56 KiB)
    # 824.917 μs (1 allocation: 576 bytes)
    # 11.529 ms (36 allocations: 1.53 MiB)
    # 8.278 ms (1 allocation: 576 bytes)

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

    # 250.716 ns (9 allocations: 1.03 KiB)
    # 252.429 ns (9 allocations: 1.03 KiB)
    #@btime Omics.Density.coun($a1_, $a2_)

end
