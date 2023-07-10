using Test: @test

using BioLab

# ---- #

const N = 10

const NU1_ = BioLab.NumberArray.shift_minimum(randn(N), "0<")

const NU2_ = BioLab.NumberArray.shift_minimum(randn(N), "0<")

const NU1S_ = NU1_ .+ 1

const NU2S_ = NU2_ .+ 1

const AR_ = (
    ([1, 1, 1], [1, 1, 1]),
    ([1, 2, 3], [10, 20, 30]),
    (
        (BioLab.Information.kde(nu1_).density, BioLab.Information.kde(nu2_).density) for
        (nu1_, nu2_) in ((NU1_, NU1_), (NU1_, NU2_), (NU1S_, NU2S_))
    )...,
)

# ---- #

for (nu1_, nu2_) in AR_

    for fu in (
        BioLab.Information.get_kullback_leibler_divergence,
        BioLab.Information.get_thermodynamic_breadth,
        BioLab.Information.get_thermodynamic_depth,
    )

        re_ = fu.(nu1_, nu2_)

        BioLab.Plot.plot_scatter(
            "",
            (nu1_, nu2_, re_);
            name_ = (1, 2, "Result"),
            layout = Dict("title" => Dict("text" => string(fu))),
        )

    end

end

# ---- #

for (nu1_, nu2_) in AR_

    for fu in (
        BioLab.Information.get_symmetric_kullback_leibler_divergence,
        BioLab.Information.get_antisymmetric_kullback_leibler_divergence,
    )

        nu3_ = (nu1_ + nu2_) / 2

        re_ = fu.(nu1_, nu2_, nu3_)

        BioLab.Plot.plot_scatter(
            "",
            (nu1_, nu2_, nu3_, re_);
            name_ = (1, 2, 3, "Result"),
            layout = Dict("title" => Dict("text" => string(fu))),
        )

    end

end

# ---- #
# TODO

for nu_ in (fill(0, 10), fill(1, 10))

    BioLab.Information.get_entropy(nu_)

end

# ---- #
# TODO

nu1_ = collect(0:10)

nu2_ = collect(0:10:100)

# ---- #
# TODO

BioLab.Information.get_mutual_information(nu1_, nu2_)

# ---- #
# TODO

bi = BioLab.Information.kde((nu1_, nu2_), npoints = (8, 8))

y = collect(bi.y)

x = collect(bi.x)

z = bi.density

BioLab.Plot.plot_heat_map("", z, y, x)

BioLab.Information.get_information_coefficient(nu1_, nu2_)
