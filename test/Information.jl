using Test: @test

using Nucleus

# ---- #

# TODO: Benchmark.

for nu_ in (zeros(10), ones(10))

    Nucleus.Information.get_entropy(nu_)

end

# ---- #

const N = 10

# ---- #

const NU1_ = randn(N)

# ---- #

const NU2_ = randn(N)

# ---- #

function get_density(nu_)

    Nucleus.Information.kde(nu_).density

end

# ---- #

const NU___ = (
    (ones(3), ones(3)),
    ([1, 2, 3], [10, 20, 30]),
    (get_density(NU1_), get_density(NU2_)),
    (get_density(NU1_ .+ minimum(NU1_)), get_density(NU2_ .+ minimum(NU2_))),
)

# ---- #

for (nu1_, nu2_) in NU___

    for fu in (
        Nucleus.Information.get_kullback_leibler_divergence,
        Nucleus.Information.get_thermodynamic_depth,
        Nucleus.Information.get_thermodynamic_breadth,
    )

        Nucleus.Plot.plot_scatter(
            "",
            (nu1_, nu2_, fu.(nu1_, nu2_));
            name_ = (1, 2, "Result"),
            layout = Dict("title" => Dict("text" => string(fu))),
        )

    end

end

# ---- #

for (nu1_, nu2_) in NU___

    for fu in (
        Nucleus.Information.get_antisymmetric_kullback_leibler_divergence,
        Nucleus.Information.get_symmetric_kullback_leibler_divergence,
    )

        nu3_ = 0.5(nu1_ + nu2_)

        Nucleus.Plot.plot_scatter(
            "",
            (nu1_, nu2_, nu3_, fu.(nu1_, nu2_, nu3_));
            name_ = (1, 2, 3, "Result"),
            layout = Dict("title" => Dict("text" => string(fu))),
        )

    end

end

# ---- #

nu1_ = collect(0:10)

# ---- #

nu2_ = collect(0:10:100)

# ---- #

Nucleus.Information.get_mutual_information(nu1_, nu2_)

# ---- #

bi = Nucleus.Information.kde((nu2_, nu1_), npoints = (8, 8))

# ---- #

y = collect(bi.y)

# ---- #

x = collect(bi.x)

# ---- #

z = bi.density

# ---- #

Nucleus.Plot.plot_heat_map("", z; y, x)

# ---- #

Nucleus.Information.get_information_coefficient(nu1_, nu2_)
