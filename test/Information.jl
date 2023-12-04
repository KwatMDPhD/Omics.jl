using Test: @test

using Nucleus

# ---- #

using Clustering: mutualinfo

# ---- #

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

    # TODO: Test.
    # TODO: Benchmark.
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

    # TODO: Test.
    # TODO: Benchmark.
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

JO = [
    1/8 1/16 1/16 1/4
    1/16 1/8 1/16 0
    1/32 1/32 1/16 0
    1/32 1/32 1/16 0
]

P1_ = sum.(eachrow(JO))
@test P1_ == [1 / 2, 1 / 4, 1 / 8, 1 / 8]

P2_ = sum.(eachcol(JO))
@test P2_ == [1 / 4, 1 / 4, 1 / 4, 1 / 4]

E1 = sum(get_entropy, P1_)
@test E1 === 7 / 4

E2 = sum(get_entropy, P2_)
@test E2 === 2.0

EJ = sum(get_entropy, JO)
@test EJ === 27 / 8

E12 = EJ - E2
@test E12 === sum(p2 * sum(get_entropy, co / p2) for (p2, co) in zip(P2_, eachcol(JO))) === 11 / 8

E21 = EJ - E1
@test E21 === sum(p1 * sum(get_entropy, ro / p1) for (p1, ro) in zip(P1_, eachrow(JO))) === 13 / 8

MU = E1 + E2 - EJ
@test MU === E1 - E12 === E2 - E21 === 3 / 8

# ---- #

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

    mu = Nucleus.Information.get_mutual_informationp(jo)

    e1 = sum(Nucleus.Information._sum_get_entropy, eachrow(jo))

    e2 = sum(Nucleus.Information._sum_get_entropy, eachcol(jo))

    @test Nucleus.Information.normalize_mutual_information(mu, e1, e2) === re_[2]

    # 1.458 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Information.normalize_mutual_information($mu, $e1, $e2)

end

# ---- #

for (jo, re_) in PE_

    @test Nucleus.Information.get_mutual_informationp(jo) === re_[1]

    # 161.271 ns (2 allocations: 192 bytes)
    # 162.202 ns (2 allocations: 192 bytes)
    #@btime Nucleus.Information.get_mutual_informationp($jo)

end

# ---- #

for (jo, re_) in PE_

    @test isapprox(Nucleus.Information.get_mutual_informatione(jo), re_[1]; atol = 1e-15)

    # 114.595 ns (0 allocations: 0 bytes)
    # 114.345 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Information.get_mutual_informatione($jo)

end

# ---- #

const MI_ = ((1:10, 1:10), (1:10, 10:-1:1), (1:10, 1:10:100))

# ---- #

for (nu1_, nu2_) in MI_

    nu1t_ = collect(nu1_)

    nu2t_ = collect(nu2_)

    re = mutualinfo(nu1t_, nu2t_; normed = false)
    @info re

    @test isapprox(Nucleus.Information.get_mutual_information(nu1t_, nu2t_), re; atol = 1e-15)

    # 1.025 μs (24 allocations: 4.53 KiB)
    # 1.067 μs (24 allocations: 4.53 KiB)
    # 1.062 μs (24 allocations: 4.53 KiB
    #@btime Nucleus.Information.get_mutual_information($nu1t_, $nu2t_)

end

# ---- #

for (nu1_, nu2_) in MI_

    nu1t_ = convert(Vector{Float64}, nu1_)

    nu2t_ = convert(Vector{Float64}, nu2_)

    for ke_ar in (
        (),
        (npoints = (4, 4),),
        (npoints = (32, 32),),
        (npoints = (64, 64),),
        (bandwidth = (1e-3, 1e-3),),
    )

        @info Nucleus.Information.get_mutual_information(nu1t_, nu2t_; ke_ar...)

        # 1.143 ms (44 allocations: 3.01 MiB)
        # 11.209 μs (34 allocations: 3.52 KiB)
        # 26.084 μs (34 allocations: 52.45 KiB)
        # 71.208 μs (40 allocations: 197.48 KiB)
        # 1.039 ms (33 allocations: 3.01 MiB)
        # 1.112 ms (44 allocations: 3.01 MiB)
        # 11.375 μs (34 allocations: 3.52 KiB)
        # 26.209 μs (34 allocations: 52.45 KiB)
        # 71.417 μs (40 allocations: 197.48 KiB)
        # 1.047 ms (33 allocations: 3.01 MiB)
        # 1.112 ms (44 allocations: 3.01 MiB)
        # 11.458 μs (34 allocations: 3.52 KiB)
        # 26.167 μs (34 allocations: 52.45 KiB)
        # 71.417 μs (40 allocations: 197.48 KiB)
        # 1.047 ms (33 allocations: 3.01 MiB)
        #@btime Nucleus.Information.get_mutual_information($nu1t_, $nu2t_; $ke_ar...)

    end

end

# ---- #

for ((nu1_, nu2_), re) in zip(MI_, (0.99498743710662, -0.99498743710662, 0.99498743710662))

    nu1t_ = collect(nu1_)

    nu2t_ = collect(nu2_)

    @test Nucleus.Information.get_information_coefficient(nu1t_, nu2t_) === re

    # 1.033 μs (24 allocations: 4.53 KiB)
    # 1.067 μs (24 allocations: 4.53 KiB)
    # 1.062 μs (24 allocations: 4.53 KiB)
    #@btime Nucleus.Information.get_information_coefficient($nu1t_, $nu2t_)

end

# ---- #

for ((nu1_, nu2_), re) in zip(MI_, (0.9938079899999066, -0.9921567416492216, 0.9938079899999067))

    nu1t_ = convert(Vector{Float64}, nu1_)

    nu2t_ = convert(Vector{Float64}, nu2_)

    @test Nucleus.Information.get_information_coefficient(nu1t_, nu2t_) === re

    # 24.750 μs (34 allocations: 52.45 KiB)
    # 24.875 μs (34 allocations: 52.45 KiB)
    # 24.708 μs (34 allocations: 52.45 KiB)
    #@btime Nucleus.Information.get_information_coefficient($nu1t_, $nu2t_)

end
