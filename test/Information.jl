using Test: @test

using BioLab

# ---- #

const N = 10

const NU1_ = randn(N)

const NU2_ = randn(N)

function get_density(nu_)

    BioLab.Information.kde(nu_).density

end

const AR_ = (
    ([1, 1, 1], [1, 1, 1]),
    ([1, 2, 3], [10, 20, 30]),
    (get_density(NU1_), get_density(NU2_)),
    (get_density(NU1_ .+ minimum(NU1_)), get_density(NU2_ .+ minimum(NU2_))),
)

# ---- #

for (nu1_, nu2_) in AR_

    for fu in (
        BioLab.Information.get_kullback_leibler_divergence,
        BioLab.Information.get_thermodynamic_depth,
        BioLab.Information.get_thermodynamic_breadth,
    )

        BioLab.Plot.plot_scatter(
            "",
            (nu1_, nu2_, fu.(nu1_, nu2_));
            name_ = (1, 2, "Result"),
            layout = Dict("title" => Dict("text" => string(fu))),
        )

    end

end

# ---- #

for (nu1_, nu2_) in AR_

    for fu in (
        BioLab.Information.get_antisymmetric_kullback_leibler_divergence,
        BioLab.Information.get_symmetric_kullback_leibler_divergence,
    )

        nu3_ = (nu1_ + nu2_) / 2

        BioLab.Plot.plot_scatter(
            "",
            (nu1_, nu2_, nu3_, fu.(nu1_, nu2_, nu3_));
            name_ = (1, 2, 3, "Result"),
            layout = Dict("title" => Dict("text" => string(fu))),
        )

    end

end

# ---- #

for nu_ in (fill(0, 10), fill(1, 10))

    BioLab.Information.get_entropy(nu_)

end

# ---- #

nu1_ = collect(0:10)

nu2_ = collect(0:10:100)

# ---- #

BioLab.Information.get_mutual_information(nu1_, nu2_)

# ---- #

bi = BioLab.Information.kde((nu1_, nu2_), npoints = (8, 8))

y = collect(bi.y)

x = collect(bi.x)

z = bi.density

BioLab.Plot.plot_heat_map("", z, y, x)

# ---- #

BioLab.Information.get_information_coefficient(nu1_, nu2_)
