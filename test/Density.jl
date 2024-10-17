using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

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

for nu_ in ([
    -1,
    0,
    1,
    2,
    2,
    3,
    3,
    3,
    4,
    4,
    4,
    4,
    5,
    5,
    5,
    5,
    5,
    6,
    6,
    6,
    6,
    7,
    7,
    7,
    8,
    8,
    9,
    10,
    11,
],)


    kd = Omics.Density.kde(nu_; boundary = extrema(nu_), npoints = UG)

    # TODO: Improve `coun` when `ug` is small
    gr_, co_ = Omics.Density.coun(nu_, UG)

    @test kd.x === gr_

    @info "" gr_ co_

    Omics.Plot.plot(
        joinpath(tempdir(), "1kernelcount.html"),
        (
            Dict(
                "type" => "bar",
                "name" => "Kernel",
                "y" => Omics.Normalization.normalize_with_sum!(kd.density),
                "x" => kd.x,
            ),
            Dict(
                "type" => "bar",
                "name" => "Count",
                "y" =>
                    Omics.Normalization.normalize_with_sum!(convert(Vector{Float64}, co_)),
                "x" => gr_,
            ),
        ),
    )

end

# ---- #

for ur in (10, 100, 1000, 10000, 100000)

    seed!(20240831)

    nu_ = rand(ur)

    # 3.724 μs (36 allocations: 1.70 KiB)
    # 365.986 ns (2 allocations: 128 bytes)
    # 5.556 μs (36 allocations: 2.47 KiB)
    # 1.363 μs (2 allocations: 128 bytes)
    # 24.625 μs (38 allocations: 9.52 KiB)
    # 11.042 μs (2 allocations: 128 bytes)
    # 412.791 μs (38 allocations: 79.77 KiB)
    # 233.416 μs (2 allocations: 128 bytes)
    # 5.044 ms (38 allocations: 782.89 KiB)
    # 2.585 ms (2 allocations: 128 bytes)

    #@btime Omics.Density.kde($nu_; boundary = $(extrema(nu_)), npoints = UG)

    #@btime Omics.Density.coun($nu_, UG)

end

# ---- #

const npoints = (UG, UG)

for (n1_, n2_) in (([1, 2, 3, 4, 6], [2, 4, 8, 16, 64]),)

    k1_, k2_, de =
        Omics.Density.ge(n1_, n2_; boundary = (extrema(n1_), extrema(n2_)), npoints)

    g1_, g2_, co = Omics.Density.coun(n1_, n2_, npoints)

    d1_, d2_, di =
        Omics.Density.coun(n1_, n2_, (Omics.Dic.index(n1_), Omics.Dic.index(n2_)))

    @test k1_ == g1_

    @test k2_ == g2_

    @test d1_ == n1_

    @test d2_ == n2_

    Omics.Plot.plot_heat_map(
        joinpath(tempdir(), "2kernel.html"),
        de;
        ro_ = k1_,
        co_ = k2_,
        la = Dict("title" => Dict("text" => "Kernel")),
    )

    Omics.Plot.plot_heat_map(
        joinpath(tempdir(), "2count.html"),
        co;
        ro_ = g1_,
        co_ = g2_,
        la = Dict("title" => Dict("text" => "Count")),
    )

    Omics.Plot.plot_heat_map(
        joinpath(tempdir(), "2countdict.html"),
        di;
        ro_ = d1_,
        co_ = d2_,
        la = Dict("title" => Dict("text" => "Count with Dict")),
    )

end

# ---- #

for ur in (10, 100, 1000, 10000)

    seed!(20240831)

    n1_ = rand(ur)

    n2_ = rand(ur)

    # 11.833 μs (49 allocations: 5.36 KiB)
    # 793.796 ns (2 allocations: 592 bytes)
    # 562.162 ns (16 allocations: 2.69 KiB)
    # 15.375 μs (49 allocations: 6.89 KiB)
    # 2.648 μs (2 allocations: 592 bytes)
    # 15.333 μs (22 allocations: 163.66 KiB)
    # 54.000 μs (52 allocations: 20.97 KiB)
    # 25.208 μs (2 allocations: 592 bytes)
    # 1.397 ms (30 allocations: 15.32 MiB)
    # 910.417 μs (52 allocations: 161.47 KiB)
    # 494.000 μs (2 allocations: 592 bytes)
    # 227.661 ms (30 allocations: 1.49 GiB)
    # 10.451 ms (52 allocations: 1.53 MiB)
    # 5.154 ms (2 allocations: 592 bytes)
    # 40.399 s (30 allocations: 149.02 GiB)

    #@btime Omics.Density.ge($n1_, $n2_; boundary = $(extrema(n1_), extrema(n2_)), npoints)

    #@btime Omics.Density.coun($n1_, $n2_, npoints)

    #@btime Omics.Density.coun($n1_, $n2_, $(Omics.Dic.index(n1_), Omics.Dic.index(n2_)))

end
