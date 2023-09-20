using Random: seed!

using Test: @test

using BioLab

# ---- #

for (cu, re) in (
    (0, -Inf),
    (0.001, -3.09),
    (0.025, -1.96),
    (0.05, -1.64),
    (0.1587, -1),
    (0.5, 0),
    (0.8413, 1),
    (0.95, 1.64),
    (0.975, 1.96),
    (0.999, 3.09),
    (1, Inf),
)

    @test isapprox(BioLab.Statistics.get_quantile(cu), re; atol = 1e-2)

end

# ---- #

seed!(20230612)

const NO_ = randn(1000)

for (co, re) in zip(
    (0, 0.001, 0.5, 0.95, 1),
    (0.0, 4.0685463561927655e-5, 0.021895485060908795, 0.06362492851958153, Inf),
)

    @test BioLab.Statistics.get_margin_of_error(NO_, co) === re

end

# ---- #

for (po, re) in zip(
    0:4,
    (NaN, 0.6189908521765288, 0.1900545163940193, 0.06362492851958153, 0.019426335022525613),
)

    seed!(20230612)

    no_ = randn(10^po)

    @test isequal(BioLab.Statistics.get_margin_of_error(no_), re)

    # 24.222 ns (0 allocations: 0 bytes)
    # 31.396 ns (0 allocations: 0 bytes)
    # 60.887 ns (0 allocations: 0 bytes)
    # 537.698 ns (0 allocations: 0 bytes)
    # 3.969 μs (0 allocations: 0 bytes)
    #@btime BioLab.Statistics.get_margin_of_error($no_)

end

# ---- #

@test isnan(BioLab.Statistics.get_p_value(1, 0))

# ---- #

const N_RA = 10

@test BioLab.Statistics.get_p_value(0, N_RA) === BioLab.Statistics.get_p_value(1, N_RA) === 0.1

# ---- #

@test BioLab.Statistics.get_p_value(2, N_RA) == 0.2

# ---- #

const NU_ = [NaN, -1, 0, 8, 9, NaN]

const N = length(NU_)

const RAE_ = Vector{Float64}()

const NA_ = fill(NaN, N)

const RA_ = [NaN, -2, -1, 0, 1, 2, 6, 7, 8, 9, 10, NaN]

# ---- #

for (fu, re) in (
    (
        <=,
        ([NaN, 0.2, 0.3, 0.8, 0.9, NaN], [NaN, 0.8999999999999999, 0.8999999999999999, 1, 1, NaN]),
    ),
    (
        >=,
        ([NaN, 0.9, 0.8, 0.3, 0.2, NaN], [NaN, 1, 1, 0.8999999999999999, 0.8999999999999999, NaN]),
    ),
)

    @test isequal(BioLab.Statistics.get_p_value(fu, NU_, RAE_), (NA_, NA_))

    @test isequal(BioLab.Statistics.get_p_value(fu, NU_, RA_), re)

    # 271.032 ns (10 allocations: 960 bytes)
    # 276.541 ns (10 allocations: 960 bytes)
    #@btime BioLab.Statistics.get_p_value($fu, $NU_, $RA_)

end

# ---- #

for (sc_, fe_x_id_x_ra, re) in
    ((NU_, reshape(RA_, N, 2), ([1], [1], [1, 0.375, 0.25], [1, 0.5625, 0.5625])),)

    nei_, poi_ = BioLab.Statistics._get_negative_positive(sc_)

    @test BioLab.Statistics.get_p_value(sc_, nei_, poi_, fe_x_id_x_ra) == re

    # 598.395 ns (24 allocations: 1.64 KiB)
    #@btime BioLab.Statistics.get_p_value($sc_, $nei_, $poi_, $fe_x_id_x_ra)

end
