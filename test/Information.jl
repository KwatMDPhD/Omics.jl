using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using KernelDensity: kde

using Random: seed!

# ---- #

for (pr_, re) in (
    #
    ([1], -0.0),
    #
    ([0.001, 0.999], 0.011407757737461138),
    ([0.01, 0.99], 0.08079313589591118),
    ([0.1, 0.9], 0.4689955935892812),
    ([0.2, 0.8], 0.7219280948873623),
    ([0.3, 0.7], 0.8812908992306927),
    ([0.4, 0.6], 0.9709505944546686),
    ([0.5, 0.5], 1.0),
    #
    ([1 / 3, 1 / 3, 1 / 3], 1.584962500721156),
    ([0.25, 0.25, 0.25, 0.25], 2.0),
    ([0.2, 0.2, 0.2, 0.2, 0.2], 2.321928094887362),
    #
    ([0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1], 3.321928094887362),
    ([0.05, 0.15, 0.05, 0.15, 0.05, 0.15, 0.05, 0.15, 0.05, 0.15], 3.133206219346495),
    ([0.01, 0.19, 0.02, 0.18, 0.03, 0.17, 0.04, 0.16, 0.05, 0.15], 2.901615909840989),
)

    @test sum(Omics.Information.get_shannon_entropy, pr_) === re

    # 6.417 ns (0 allocations: 0 bytes)
    # 11.094 ns (0 allocations: 0 bytes)
    # 11.094 ns (0 allocations: 0 bytes)
    # 12.012 ns (0 allocations: 0 bytes)
    # 12.012 ns (0 allocations: 0 bytes)
    # 12.012 ns (0 allocations: 0 bytes)
    # 12.012 ns (0 allocations: 0 bytes)
    # 12.012 ns (0 allocations: 0 bytes)
    # 16.741 ns (0 allocations: 0 bytes)
    # 21.439 ns (0 allocations: 0 bytes)
    # 26.188 ns (0 allocations: 0 bytes)
    # 50.134 ns (0 allocations: 0 bytes)
    # 50.109 ns (0 allocations: 0 bytes)
    # 50.185 ns (0 allocations: 0 bytes)
    @btime sum(Omics.Information.get_shannon_entropy, $pr_)

end

# ---- #

function plot(y_, na_, fu)

    Omics.Plot.plot(
        "",
        [Dict("name" => na_[id], "y" => y_[id]) for id in eachindex(y_)],
        Dict("title" => Dict("text" => string(fu))),
    )

end

seed!(20241015)

for (n1_, n2_) in (([1, 2, 3], [2, 3, 4]), (kde(rand(10)).density, kde(randn(10)).density))

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
