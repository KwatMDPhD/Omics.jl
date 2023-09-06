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

    # 24.347 ns (0 allocations: 0 bytes)
    # 31.648 ns (0 allocations: 0 bytes)
    # 61.247 ns (0 allocations: 0 bytes)
    # 537.698 ns (0 allocations: 0 bytes)
    # 3.974 μs (0 allocations: 0 bytes)
    # 40.583 μs (0 allocations: 0 bytes)
    #@btime BioLab.Statistics.get_margin_of_error($nu_)

end

# ---- #

const RA_ = collect(1:10)

# ---- #

@test BioLab.Statistics._get_p_value(0, RA_) == BioLab.Statistics._get_p_value(1, RA_) == 0.1

@test BioLab.Statistics._get_p_value(2, RA_) == 0.2

# ---- #

const NU_ = (1, 2, 9, 10)

const RE_ = (0.1, 0.2, 0.9, 1)

# ---- #

for (nu, re) in zip(NU_, RE_)

    @test BioLab.Statistics.get_p_value_for_less(nu, RA_) == re

    # 6.125 ns (0 allocations: 0 bytes)
    # 8.291 ns (0 allocations: 0 bytes)
    # 6.125 ns (0 allocations: 0 bytes)
    # 6.125 ns (0 allocations: 0 bytes)
    #@btime BioLab.Statistics.get_p_value_for_less($nu, $RA_)

end

# ---- #

for (nu, re) in zip(NU_, reverse(RE_))

    @test BioLab.Statistics.get_p_value_for_more(nu, RA_) == re

    # 6.125 ns (0 allocations: 0 bytes)
    # 6.125 ns (0 allocations: 0 bytes)
    # 6.125 ns (0 allocations: 0 bytes)
    # 6.125 ns (0 allocations: 0 bytes)
    #@btime BioLab.Statistics.get_p_value_for_more($nu, $RA_)

end

# ---- #

const NU2_ = [0, 1, 8, 9]

const RA2_ = collect(0:9)

# ---- #

for (fu, re) in (
    (BioLab.Statistics.get_p_value_for_less, ([0.1, 0.2, 0.9, 1], [0.4, 0.4, 1, 1])),
    (BioLab.Statistics.get_p_value_for_more, ([1, 0.9, 0.2, 0.1], [1, 1, 0.4, 0.4])),
)

    @test BioLab.Statistics.get_p_value_adjust(fu, NU2_, RA2_) == re

    # 319.013 ns (10 allocations: 864 bytes)
    # 324.382 ns (10 allocations: 864 bytes)
    #@btime BioLab.Statistics.get_p_value_adjust($fu, $NU2_, $RA2_)

end

# ---- #

@test BioLab.Statistics.get_p_value_adjust(NU2_, RA2_) ==
      ([0.1, 0.2, 0.2, 0.1], [0.4, 0.4, 0.4, 0.4])

# 720.055 ns (22 allocations: 1.88 KiB)
#@btime BioLab.Statistics.get_p_value_adjust($NU2_, $RA2_);
