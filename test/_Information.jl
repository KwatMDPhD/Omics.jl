using KernelDensity

include("_.jl")

# ---- #

for nu_ in (fill(0.0, 10), fill(1.0, 10))

    # TODO: `@test`.
    BioLab.Information.get_entropy(nu_)

    # @code_warntype BioLab.Information.get_entropy(nu_)

    # 1.167 ns (0 allocations: 0 bytes)
    # @btime BioLab.Information.get_entropy($nu_)

end

# ---- #

n = 10

nu1_ = BioLab.VectorNumber.shift_minimum(randn(n), "0<")

nu2_ = BioLab.VectorNumber.shift_minimum(randn(n), "0<")

nu1s_ = [nu + 1.0 for nu in nu1_]

nu2s_ = [nu + 1.0 for nu in nu2_]

ar_ = (
    ([1.0, 1, 1], [1.0, 1, 1]),
    ([1.0, 2, 3], [10.0, 20, 30]),
    (
        (kde(nu1_).density, kde(nu2_).density) for
        (nu1_, nu2_) in ((nu1_, nu1_), (nu1_, nu2_), (nu1s_, nu2s_))
    )...,
)

# ---- #

for (nu1_, nu2_) in ar_

    fu = BioLab.Information.get_kullback_leibler_divergence

    # TODO: `@test`.
    re_ = fu(nu1_, nu2_)

    BioLab.Plot.plot_scatter((nu1_, nu2_, re_); name_ = [1, 2, string(fu)])

    # @code_warntype fu(nu1_, nu2_)

    # 32.696 ns (1 allocation: 80 bytes)
    # 34.696 ns (1 allocation: 80 bytes)
    # 6.990 μs (1 allocation: 16.12 KiB)
    # 7.917 μs (1 allocation: 16.12 KiB)
    # 7.927 μs (1 allocation: 16.12 KiB)
    # @btime $fu($nu1_, $nu2_)

end

# ---- #

for (nu1_, nu2_) in ar_

    fu = BioLab.Information.get_thermodynamic_breadth

    # TODO: `@test`.
    re_ = fu(nu1_, nu2_)

    BioLab.Plot.plot_scatter((nu1_, nu2_, re_); name_ = [1, 2, string(fu)])

    # @code_warntype fu(nu1_, nu2_)

    # 80.364 ns (3 allocations: 240 bytes)
    # 86.498 ns (3 allocations: 240 bytes)
    # 14.417 μs (3 allocations: 48.38 KiB)
    # 16.083 μs (3 allocations: 48.38 KiB)
    # 16.125 μs (3 allocations: 48.38 KiB)
    # @btime $fu($nu1_, $nu2_)

end

# ---- #

for (nu1_, nu2_) in ar_

    fu = BioLab.Information.get_thermodynamic_depth

    # TODO: `@test`.
    re_ = fu(nu1_, nu2_)

    BioLab.Plot.plot_scatter((nu1_, nu2_, re_); name_ = [1, 2, string(fu)])

    # @code_warntype fu(nu1_, nu2_)

    # 80.364 ns (3 allocations: 240 bytes)
    # 86.498 ns (3 allocations: 240 bytes)
    # 14.417 μs (3 allocations: 48.38 KiB)
    # 16.083 μs (3 allocations: 48.38 KiB)
    # 16.125 μs (3 allocations: 48.38 KiB)
    # @btime $fu($nu1_, $nu2_)

end

# ---- #

for (nu1_, nu2_) in ar_

    nu3_ = (nu1_ + nu2_) / 2

    fu = BioLab.Information.get_symmetric_kullback_leibler_divergence

    # TODO: `@test`.
    re_ = fu(nu1_, nu2_, nu3_)

    BioLab.Plot.plot_scatter((nu1_, nu2_, nu3_, re_); name_ = [1, 2, 3, string(fu)])

    # @code_warntype fu(nu1_, nu2_, nu3_)

    # 80.877 ns (3 allocations: 240 bytes)
    # 86.671 ns (3 allocations: 240 bytes)
    # 14.416 μs (3 allocations: 48.38 KiB) 
    # 16.000 μs (3 allocations: 48.38 KiB)
    # 16.000 μs (3 allocations: 48.38 KiB)
    # @btime $fu($nu1_, $nu2_, $nu3_)

end

# ---- #

for (nu1_, nu2_) in ar_

    nu3_ = (nu1_ + nu2_) / 2

    fu = BioLab.Information.get_antisymmetric_kullback_leibler_divergence

    # TODO: `@test`.
    re_ = fu(nu1_, nu2_, nu3_)

    BioLab.Plot.plot_scatter((nu1_, nu2_, nu3_, re_); name_ = [1, 2, 3, string(fu)])

    # @code_warntype fu(nu1_, nu2_, nu3_)

    # 80.877 ns (3 allocations: 240 bytes)
    # 86.671 ns (3 allocations: 240 bytes)
    # 14.416 μs (3 allocations: 48.38 KiB) 
    # 16.000 μs (3 allocations: 48.38 KiB)
    # 16.000 μs (3 allocations: 48.38 KiB)
    # @btime $fu($nu1_, $nu2_, $nu3_)

end

# ---- #

nu1_ = collect(0.0:10)

nu2_ = collect(0.0:10:100)

# TODO: `@test`.
println(BioLab.Information.get_mutual_information(nu1_, nu2_))

# @code_warntype BioLab.Information.get_mutual_information(nu1_, nu2_)

# 1.167 ns (0 allocations: 0 bytes)
# @btime BioLab.Information.get_mutual_information($nu1_, $nu2_)

# ---- #

bi = kde((nu1_, nu2_), npoints = (8, 8))

y = collect(bi.y)

x = collect(bi.x)

z = bi.density

BioLab.Plot.plot_heat_map(z, y, x)

# TODO: `@test`.
println(BioLab.Information.get_information_coefficient(nu1_, nu2_))

# @code_warntype BioLab.Information.get_information_coefficient(nu1_, nu2_)

# 1.167 ns (0 allocations: 0 bytes)
# @btime BioLab.Information.get_information_coefficient($nu1_, $nu2_)
