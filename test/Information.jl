using KernelDensity

include("environment.jl")

# ---- #

for nu_ in (fill(0, 10), fill(1, 10))

    println(BioLab.Information.get_entropy(nu_))

end

# ---- #

n = 10

nu1_ = BioLab.NumberVector.shift_minimum(randn(n), "0<")

nu2_ = BioLab.NumberVector.shift_minimum(randn(n), "0<")

nu1s_ = [nu + 1 for nu in nu1_]

nu2s_ = [nu + 1 for nu in nu2_]

ar_ = (
    ([1, 1, 1], [1, 1, 1]),
    ([1, 2, 3], [10, 20, 30]),
    (
        (kde(nu1_).density, kde(nu2_).density) for
        (nu1_, nu2_) in ((nu1_, nu1_), (nu1_, nu2_), (nu1s_, nu2s_))
    )...,
)

# ---- #

for (nu1_, nu2_) in ar_

    for fu in (
        BioLab.Information.get_kullback_leibler_divergence,
        BioLab.Information.get_thermodynamic_breadth,
        BioLab.Information.get_thermodynamic_depth,
    )

        re_ = map(fu, nu1_, nu2_)

        BioLab.Plot.plot_scatter(
            (nu1_, nu2_, re_);
            name_ = [1, 2, "fu"],
            layout = Dict("title" => Dict("text" => string(fu))),
        )

    end

end

# ---- #

for (nu1_, nu2_) in ar_

    for fu in (
        BioLab.Information.get_symmetric_kullback_leibler_divergence,
        BioLab.Information.get_antisymmetric_kullback_leibler_divergence,
    )

        nu3_ = (nu1_ + nu2_) / 2

        re_ = map(fu, nu1_, nu2_, nu3_)

        BioLab.Plot.plot_scatter(
            (nu1_, nu2_, nu3_, re_);
            name_ = [1, 2, 3, "fu"],
            layout = Dict("title" => Dict("text" => string(fu))),
        )

    end

end

# ---- #

nu1_ = collect(0:10)

nu2_ = collect(0:10:100)

# ---- #

BioLab.Information.get_mutual_information(nu1_, nu2_)

# ---- #

bi = kde((nu1_, nu2_), npoints = (8, 8))

y = collect(bi.y)

x = collect(bi.x)

z = bi.density

BioLab.Plot.plot_heat_map(z, y, x)

BioLab.Information.get_information_coefficient(nu1_, nu2_)
