using Test: @test

using Nucleus

# ---- #

using Clustering: mutualinfo

# ---- #

for (nu_, re) in (
    (zeros(10), 0.0),
    (ones(10), -0.0),
    (1:10, -102.08283055193493),
    ([0, 2, 4, 8], -23.56700413903814),
)

    @test sum(Nucleus.Information.get_entropy, nu_) === re

    # 6.416 ns (0 allocations: 0 bytes)
    # 6.750 ns (0 allocations: 0 bytes)
    # 32.780 ns (0 allocations: 0 bytes)
    # 32.445 ns (0 allocations: 0 bytes)
    # 35.582 ns (0 allocations: 0 bytes)
    # 34.995 ns (0 allocations: 0 bytes)
    # 13.443 ns (0 allocations: 0 bytes)
    # 12.596 ns (0 allocations: 0 bytes)
    #@btime sum(Nucleus.Information.get_entropy(nu) for nu in $nu_)
    #@btime sum(Nucleus.Information.get_entropy, $nu_)

end

# ---- #

nu_ = 1:1000

# 3.453 μs (0 allocations: 0 bytes)
# 3.359 μs (0 allocations: 0 bytes)
#@btime sum(Nucleus.Information.get_entropy(nu) for nu in $nu_);
#@btime sum(Nucleus.Information.get_entropy, $nu_);

# ---- #

# TODO: Benchmark.

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

jo = [
    1/8 1/16 1/16 1/4
    1/16 1/8 1/16 0
    1/32 1/32 1/16 0
    1/32 1/32 1/16 0
]

function get_entropy(nu)

    iszero(nu) ? 0.0 : -nu * log2(nu)

end

p1_ = sum.(eachrow(jo))
@test p1_ == [1 / 2, 1 / 4, 1 / 8, 1 / 8]

p2_ = sum.(eachcol(jo))
@test p2_ == [1 / 4, 1 / 4, 1 / 4, 1 / 4]

h1 = sum(get_entropy, p1_)
@test h1 === 7 / 4

h2 = sum(get_entropy, p2_)
@test h2 === 2.0

hj = sum(get_entropy, jo)
@test hj === 27 / 8

h12 = hj - h2
@test h12 === sum(p2 * sum(get_entropy, co / p2) for (co, p2) in zip(eachcol(jo), p2_)) === 11 / 8

h21 = hj - h1
@test h21 === sum(p1 * sum(get_entropy, ro / p1) for (ro, p1) in zip(eachrow(jo), p1_)) === 13 / 8

mu = h1 + h2 - hj
@test mu === h1 - h12 === h2 - h21 === 3 / 8

# ---- #

for (jo, re_) in (
    (
        [
            0.2 0 0 0 0
            0 0.2 0 0 0
            0.001 0 0.199 0 0
            0.002 0 0 0.198 0
            0.006 0.002 0 0 0.192
        ],
        (1.5534700710552343, 0.9653404496537963),
    ),
    (
        [
            0.2 0 0 0 0
            0.001 0 0.199 0 0
            0.006 0.002 0 0 0.192
            0.002 0 0 0.198 0
            0 0.2 0 0 0
        ],
        (1.5534700710552343, 0.9653404496537963),
    ),
)

    for (no, re) in zip((false, true), re_)

        atol = 1e-15

        @test isapprox(Nucleus.Information.get_mutual_informationp(jo; no), re; atol)

        @test isapprox(Nucleus.Information.get_mutual_informatione(jo; no), re; atol)

        # 160.321 ns (2 allocations: 192 bytes)
        # 115.741 ns (0 allocations: 0 bytes)
        # 199.862 ns (2 allocations: 192 bytes)
        # 115.741 ns (0 allocations: 0 bytes)
        # 161.352 ns (2 allocations: 192 bytes)
        # 116.240 ns (0 allocations: 0 bytes)
        # 200.982 ns (2 allocations: 192 bytes)
        # 116.721 ns (0 allocations: 0 bytes)

        #@btime Nucleus.Information.get_mutual_informationp($jo; no = $no)

        #@btime Nucleus.Information.get_mutual_informatione($jo; no = $no)

    end

end

# ---- #

for (nu1_, nu2_) in (([1, 2, 3], [1, 2, 3]), ([3, 2, 1], [3, 2, 1]))

    atol = 1e-15

    @test isapprox(
        Nucleus.Information.get_mutual_information(nu1_, nu2_),
        mutualinfo(nu1_, nu2_; normed = false);
        atol,
    )

    @test isapprox(
        Nucleus.Information.get_mutual_information(nu1_, nu2_; no = true),
        mutualinfo(nu1_, nu2_;);
        atol,
    )

    # 543.883 ns (22 allocations: 2.38 KiB)
    # 544.548 ns (22 allocations: 2.38 KiB)
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
