using Test: @test

using Nucleus

# ---- #

using Clustering: mutualinfo

# ---- #

# TODO: Test.
# TODO: Benchmark.
const N = 10

# ---- #

const NU1_ = randn(N)

# ---- #

const NU2_ = randn(N)

# ---- #

const NU___ = (
    (ones(3), ones(3)),
    ([1, 2, 3], [10, 20, 30]),
    (Nucleus.Information.kde(NU1_).density, Nucleus.Information.kde(NU2_).density),
    (
        Nucleus.Information.kde(NU1_ .+ minimum(NU1_)).density,
        Nucleus.Information.kde(NU2_ .+ minimum(NU2_)).density,
    ),
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

for (nu_, re) in (
    (zeros(10), 0.0),
    (ones(10), -0.0),
    (1:10, -102.08283055193493),
    ([0, 2, 4, 8], -23.56700413903814),
)

    @test sum(Nucleus.Information.get_entropy, nu_) === re

    # 6.709 ns (0 allocations: 0 bytes)
    # 32.445 ns (0 allocations: 0 bytes)
    # 34.953 ns (0 allocations: 0 bytes)
    # 12.554 ns (0 allocations: 0 bytes)
    #@btime sum(Nucleus.Information.get_entropy, $nu_)

end

# ---- #

function get_entropy(nu)

    iszero(nu) ? 0.0 : -nu * log2(nu)

end

const JO = [
    1/8 1/16 1/16 1/4
    1/16 1/8 1/16 0
    1/32 1/32 1/16 0
    1/32 1/32 1/16 0
]

const P1_ = sum.(eachrow(JO))

@test P1_ == [1 / 2, 1 / 4, 1 / 8, 1 / 8]

const P2_ = sum.(eachcol(JO))

@test P2_ == [1 / 4, 1 / 4, 1 / 4, 1 / 4]

const E1 = sum(get_entropy, P1_)

@test E1 === 7 / 4

const E2 = sum(get_entropy, P2_)

@test E2 === 2.0

const EJ = sum(get_entropy, JO)

@test EJ === 27 / 8

const E12 = EJ - E2

@test E12 === sum(p2 * sum(get_entropy, co / p2) for (p2, co) in zip(P2_, eachcol(JO))) === 11 / 8

const E21 = EJ - E1

@test E21 === sum(p1 * sum(get_entropy, ro / p1) for (p1, ro) in zip(P1_, eachrow(JO))) === 13 / 8

const MU = E1 + E2 - EJ

@test MU === E1 - E12 === E2 - E21 === 3 / 8

# ---- #

# https://cdanielaam.medium.com/how-to-compare-and-evaluate-unsupervised-clustering-methods-84f3617e3769
# TODO: Shuffle.
const PE_ = (
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

# ---- #

for (jo, re_) in PE_

    @test Nucleus.Information._get_mutual_information_using_probability(jo) === re_[1]

    # 161.193 ns (2 allocations: 192 bytes)
    # 162.149 ns (2 allocations: 192 bytes)
    #@btime Nucleus.Information._get_mutual_information_using_probability($jo)

end

# ---- #

for (jo, re_) in PE_

    @test isapprox(
        Nucleus.Information._get_mutual_information_using_entropy(jo),
        re_[1];
        atol = 1e-15,
    )

    # 115.115 ns (0 allocations: 0 bytes)
    # 115.115 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Information._get_mutual_information_using_entropy($jo)

end

# ---- #

const MI_ = ((1:10, 1:10), (1:10, 10:-1:1), (1:10, 1:10:100))

# ---- #

for (nu1_, nu2_) in MI_

    nu1i_ = convert(Vector{Int}, nu1_)

    nu2i_ = convert(Vector{Int}, nu2_)

    re = mutualinfo(nu1i_, nu2i_; normed = false)

    @info re

    @test isapprox(Nucleus.Information.get_mutual_information(nu1i_, nu2i_), re; atol = 1e-15)

    # 1.012 μs (24 allocations: 4.53 KiB)
    # 1.046 μs (24 allocations: 4.53 KiB)
    # 1.050 μs (24 allocations: 4.53 KiB
    #@btime Nucleus.Information.get_mutual_information($nu1i_, $nu2i_)

end

# ---- #

for (nu1_, nu2_) in MI_

    nu1f_ = convert(Vector{Float64}, nu1_)

    nu2f_ = convert(Vector{Float64}, nu2_)

    # TODO: Test.
    for ke_ar in (
        (npoints = (4, 4),),
        (npoints = (32, 32),),
        (npoints = (64, 64),),
        (),
        (bandwidth = (1e-3, 1e-3),),
    )

        @info Nucleus.Information.get_mutual_information(nu1f_, nu2f_; ke_ar...)

        # 11.250 μs (34 allocations: 3.52 KiB)
        # 26.292 μs (34 allocations: 52.45 KiB)
        # 71.291 μs (40 allocations: 197.48 KiB)
        # 1.110 ms (44 allocations: 3.01 MiB)
        # 1.055 ms (33 allocations: 3.01 MiB)
        # 11.333 μs (34 allocations: 3.52 KiB)
        # 26.083 μs (34 allocations: 52.45 KiB)
        # 71.458 μs (40 allocations: 197.48 KiB)
        # 1.110 ms (44 allocations: 3.01 MiB)
        # 1.049 ms (33 allocations: 3.01 MiB)
        # 11.292 μs (34 allocations: 3.52 KiB)
        # 26.000 μs (34 allocations: 52.45 KiB)
        # 71.375 μs (40 allocations: 197.48 KiB)
        # 1.112 ms (44 allocations: 3.01 MiB)
        # 1.051 ms (33 allocations: 3.01 MiB)
        #@btime Nucleus.Information.get_mutual_information($nu1f_, $nu2f_; $ke_ar...)

    end

end

# ---- #

for ((nu1_, nu2_), (rei, ref)) in
    zip(MI_, ((1.0, 1.0), (-1.0, -1.0), (0.99498743710662, 0.9938079899999067)))

    nu1i_ = convert(Vector{Int}, nu1_)

    nu2i_ = convert(Vector{Int}, nu2_)

    nu1f_ = convert(Vector{Float64}, nu1_)

    nu2f_ = convert(Vector{Float64}, nu2_)

    @test Nucleus.Information.get_information_coefficient(nu1i_, nu2i_) === rei

    @test Nucleus.Information.get_information_coefficient(nu1f_, nu2f_) === ref

    # 6.458 ns (0 allocations: 0 bytes)
    # 10.135 ns (0 allocations: 0 bytes)
    # 39.230 ns (0 allocations: 0 bytes)
    # 39.315 ns (0 allocations: 0 bytes)
    # 1.129 μs (24 allocations: 4.53 KiB)
    # 24.459 μs (34 allocations: 52.45 KiB)

    #@btime Nucleus.Information.get_information_coefficient($nu1i_, $nu2i_)

    #@btime Nucleus.Information.get_information_coefficient($nu1f_, $nu2f_)

end

# ---- #

for (nu1_, nu2_, re, red) in (
    # allequal
    ([1], [2], NaN, NaN),
    ([1, 1], [2, 2], NaN, NaN),
    ([1, 1], [1, 2], NaN, NaN),
    ([1, 2], [1, 1], NaN, NaN),
    # ==
    ([1, 2], [1, 2], 1.0, 0.0),
    ([1, 2], [1, 2.0], 1.0, 0.0),
    ([1, 2], [1, 2 + eps()], 1.0, 0.0),
    # Integer
    ([1, 2], [1, 3], 0.8660254037844386, 0.0669872981077807),
    ([1, 2], [1, 4], 0.8660254037844386, 0.0669872981077807),
    # Integer vs AbstractFloat
    ([1, 2, 3], [1, 2, 4], 0.9428090415820634, 0.028595479208968322),
    ([1.0, 2, 3], [1, 2, 4], 0.9383956314224317, 0.030802184288784173),
    # ~
    # TODO: Improve 2-Float64 cases.
    ([1, 2], [1, 2.001], 1.4713717742362244e-7, 0.4999999264314113),
    ([1, 2, 3], [1, 2, 3.001], 0.9428090415817324, 0.0285954792091338),
    ([1, 2, 3, 4], [1, 2, 3, 4.001], 0.9682458365517885, 0.015877081724105735),
)

    @test Nucleus.Information.get_information_coefficient(nu1_, nu2_) === re

    # 3.333 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.625 ns (0 allocations: 0 bytes)
    # 4.875 ns (0 allocations: 0 bytes)
    # 6.125 ns (0 allocations: 0 bytes)
    # 7.959 ns (0 allocations: 0 bytes)
    # 567.027 ns (22 allocations: 2.31 KiB)
    # 564.989 ns (22 allocations: 2.31 KiB)
    # 650.816 ns (22 allocations: 2.38 KiB)
    # 25.000 μs (34 allocations: 52.33 KiB)
    # 23.541 μs (34 allocations: 52.33 KiB)
    # 24.291 μs (34 allocations: 52.33 KiB)
    # 24.583 μs (34 allocations: 52.36 KiB)
    #@btime Nucleus.Information.get_information_coefficient($nu1_, $nu2_)

    @test Nucleus.Information.get_information_coefficient_distance(nu1_, nu2_) === red

end

# ---- #

for (jo, re_) in PE_

    mu = Nucleus.Information._get_mutual_information_using_probability(jo)

    e1 = sum(Nucleus.Information._sum_get_entropy, eachrow(jo))

    e2 = sum(Nucleus.Information._sum_get_entropy, eachcol(jo))

    @test Nucleus.Information.normalize_mutual_information(mu, e1, e2) === re_[2]

    # 1.458 ns (0 allocations: 0 bytes)
    # 1.459 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Information.normalize_mutual_information($mu, $e1, $e2)

end
