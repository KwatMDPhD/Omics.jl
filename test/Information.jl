using Test: @test

using Nucleus

# TODO: Benchmark.

# ---- #

using Clustering: mutualinfo

# ---- #

for (nu_, re) in (
    (zeros(10), 0.0),
    (ones(10), 0.0),
    (1:10, -102.08283055193493),
    ([0, 2, 4, 8], -23.56700413903814),
)

    @test Nucleus.Information.get_entropy(nu_) === re

    # 8.291 ns (0 allocations: 0 bytes)
    # 31.983 ns (0 allocations: 0 bytes)
    # 34.701 ns (0 allocations: 0 bytes)
    # 12.804 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Information.get_entropy($nu_)

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

for (jo, re_) in ((
    [
        0.2 0 0 0 0
        0 0.2 0 0 0
        0.001 0 0.199 0 0
        0.002 0 0 0.198 0
        0.006 0.002 0 0 0.192
    ],
    (1.5534700710552343, 0.9653404496537963),
),)

    for (no, re) in zip((false, true), re_)

        @test Nucleus.Information.get_mutual_information(jo; no) === re

        # 160.428 ns (2 allocations: 192 bytes)
        # 197.831 ns (2 allocations: 192 bytes)
        #@btime Nucleus.Information.get_mutual_information($jo; no = $no)

    end

end

# ---- #

for (nu1_, nu2_) in (([1, 2, 3], [1, 2, 3]), ([3, 2, 1], [3, 2, 1]))

    @test isapprox(
        Nucleus.Information.get_mutual_information(nu1_, nu2_),
        mutualinfo(nu1_, nu2_; normed = false),
        atol = 1e-15,
    )

    @test isapprox(
        Nucleus.Information.get_mutual_information(nu1_, nu2_; no = true),
        mutualinfo(nu1_, nu2_;),
        atol = 1e-15,
    )

    # 578.522 ns (24 allocations: 2.53 KiB)
    # 578.527 ns (24 allocations: 2.53 KiB)
    #@btime Nucleus.Information.get_mutual_information($nu1_, $nu2_)

end

# ---- #

nu1_ = collect(0:10)

# ---- #

nu2_ = collect(0:10:100)

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
