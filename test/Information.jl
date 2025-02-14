using KernelDensity: kde

using Random: seed!

using Test: @test

using Omics

# ---- #

function plot(na_, yc_, fu)

    Omics.Plot.plot(
        "",
        map((na, yc) -> Dict("name" => na, "y" => yc), na_, yc_),
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
        Omics.Information.get_jensen_shannon_divergence,
    )

        plot((1, 2, "Result"), (n1_, n2_, map(fu, n1_, n2_)), fu)

    end

    for fu in (
        Omics.Information.get_antisymmetric_kullback_leibler_divergence,
        Omics.Information.get_symmetric_kullback_leibler_divergence,
    )

        n3_ = (n1_ + n2_) * 0.5

        plot((1, 2, 3, "Result"), (n1_, n2_, n3_, map(fu, n1_, n2_, n3_)), fu)

    end

end
