using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using KernelDensity: kde

using Random: seed!

# ---- #

function plot(yc_, na_, fu)

    Omics.Plot.plot(
        "",
        [Dict("name" => na_[id], "y" => yc_[id]) for id in eachindex(yc_)],
        Dict("title" => Dict("text" => string(fu))),
    )

end

# ---- #

seed!(20241015)

for (n1_, n2_) in (([1, 2, 3], [2, 3, 4]), (kde(randn(10)).density, kde(randn(10)).density))

    for fu in (
        Omics.Information.get_kullback_leibler_divergence,
        Omics.Information.get_thermodynamic_depth,
        Omics.Information.get_thermodynamic_breadth,
    )

        plot((n1_, n2_, map(fu, n1_, n2_)), (1, 2, "Result"), fu)

    end

    for fu in (
        Omics.Information.get_antisymmetric_kullback_leibler_divergence,
        Omics.Information.get_symmetric_kullback_leibler_divergence,
    )

        n3_ = (n1_ + n2_) / 2

        plot((n1_, n2_, n3_, map(fu, n1_, n2_, n3_)), (1, 2, 3, "Result"), fu)

    end

end
