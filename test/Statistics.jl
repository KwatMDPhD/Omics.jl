using Random: seed!

using Test: @test

using BioLab

# ---- #

for (cu, re) in (
    (0, -Inf),
    (0.001, -3.09),
    (0.025, -1.96),
    (0.05, -1.64),
    (0.5, 0),
    (0.95, 1.64),
    (0.975, 1.96),
    (0.999, 3.09),
    (1, Inf),
)

    @test isapprox(BioLab.Statistics.get_z_score(cu), re; atol = 1e-2)

end

# ---- #

for (po, re) in zip(
    0:5,
    (
        NaN,
        0.6189908521765288,
        0.1900545163940193,
        0.06362492851958153,
        0.019426335022525613,
        0.00620269175436949,
    ),
)

    seed!(20230612)

    nu_ = randn(10^po)

    @test isequal(BioLab.Statistics.get_margin_of_error(nu_), re)

    # 24.389 ns (0 allocations: 0 bytes)
    # 31.606 ns (0 allocations: 0 bytes)
    # 61.204 ns (0 allocations: 0 bytes)
    # 537.481 ns (0 allocations: 0 bytes)
    # 3.969 μs (0 allocations: 0 bytes)
    # 40.583 μs (0 allocations: 0 bytes)
    #@btime BioLab.Statistics.get_margin_of_error($nu_)

end

# ---- #

const N = 10

@test BioLab.Statistics.get_p_value(0, N) === BioLab.Statistics.get_p_value(1, N) === 0.1

@test BioLab.Statistics.get_p_value(2, N) == 0.2

# ---- #

const NU_ = [0, 1, 8, 9]

const RA_ = collect(0:9)

for (fu, re) in
    ((<=, ([0.1, 0.2, 0.9, 1], [0.4, 0.4, 1, 1])), (>=, ([1, 0.9, 0.2, 0.1], [1, 1, 0.4, 0.4])))

    @test BioLab.Statistics.get_p_value(fu, NU_, RA_) == re

    # 274.209 ns (10 allocations: 864 bytes)
    # 285.564 ns (10 allocations: 864 bytes)
    #@btime BioLab.Statistics.get_p_value($fu, $NU_, $RA_)

end

# ---- #

@test BioLab.Statistics.get_p_value(NU_, RA_) == ([0.1, 0.2, 0.2, 0.1], [0.4, 0.4, 0.4, 0.4])

# 618.667 ns (22 allocations: 1.88 KiB)
#@btime BioLab.Statistics.get_p_value($NU_, $RA_);
