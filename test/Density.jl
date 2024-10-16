using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using KernelDensity: kde

using Random: seed!

# ---- #

for (nu_, ug, re) in (
    ([0, 1], 2, 0.0:1:1),
    ([1, 0], 3, 0.0:0.5:1),
    ([-1, 1], 2, -1.0:2:1),
    ([1, -1], 3, -1.0:1:1),
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

    @test Omics.Density.find(gr_, nu) === re

    # 2.708 ns (0 allocations: 0 bytes)
    # 2.709 ns (0 allocations: 0 bytes)
    # 2.708 ns (0 allocations: 0 bytes)
    # 3.000 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.916 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    #@btime Omics.Density.find($gr_, $nu)

end

# ---- #

const UG = 8

# ---- #

seed!(20240830)

const NU_ = randn(100)

# ---- #

kd = kde(NU_; boundary = extrema(NU_), npoints = UG)

Omics.Plot.plot(
    "",
    (Dict("type" => "bar", "y" => kd.density, "x" => kd.x),),
    Dict("title" => Dict("text" => "Kernel")),
)

# ---- #

gr_, co_ = Omics.Density.coun(NU_, UG)

@test gr_ === kd.x

Omics.Plot.plot(
    "",
    (Dict("type" => "bar", "y" => co_, "x" => gr_),),
    Dict("title" => Dict("text" => "Count")),
)

# ---- #

for up in (10, 100, 1000, 10000, 100000)

    seed!(20240831)

    nu_ = rand(up)

    # 3.750 μs (36 allocations: 1.70 KiB)
    # 366.183 ns (2 allocations: 128 bytes)
    # 6.058 μs (36 allocations: 2.47 KiB)
    # 1.363 μs (2 allocations: 128 bytes)
    # 29.666 μs (38 allocations: 9.52 KiB)
    # 11.125 μs (2 allocations: 128 bytes)
    # 475.333 μs (38 allocations: 79.77 KiB)
    # 241.833 μs (2 allocations: 128 bytes)
    # 5.576 ms (38 allocations: 782.89 KiB)
    # 2.598 ms (2 allocations: 128 bytes)

    #@btime kde($nu_; boundary = extrema($nu_), npoints = UG)

    #@btime Omics.Density.coun($nu_, UG)

end

# ---- #

const N1_ = [1, 2, 3, 4, 6]

const N2_ = [2, 4, 8, 16, 64]

# ---- #

yc_, xc_, de =
    Omics.Density.ge(N1_, N2_; boundary = (extrema(N2_), extrema(N1_)), npoints = (UG, UG))

Omics.Plot.plot_heat_map(
    "",
    de;
    ro_ = yc_,
    co_ = xc_,
    la = Dict("title" => Dict("text" => "Kernel")),
)

# ---- #

g1_, g2_, co = Omics.Density.coun(N1_, N2_, UG)

@test g1_ === yc_

@test g2_ === xc_

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

    #@btime Omics.Density.ge(
    #    $n1_,
    #    $n2_;
    #    boundary = (extrema($n2_), extrema($n1_)),
    #    npoints = (UG, UG),
    #)

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

    # 181.443 ns (10 allocations: 912 bytes)
    # 205.952 ns (10 allocations: 912 bytes)
    #@btime Omics.Density.coun($a1_, $a2_)

end
