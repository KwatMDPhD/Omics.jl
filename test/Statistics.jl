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

    # 3.333 ns (0 allocations: 0 bytes)
    # 12.137 ns (0 allocations: 0 bytes)
    # 12.096 ns (0 allocations: 0 bytes)
    # 7.458 ns (0 allocations: 0 bytes)
    # 7.173 ns (0 allocations: 0 bytes)
    # 7.208 ns (0 allocations: 0 bytes)
    # 7.166 ns (0 allocations: 0 bytes)
    # 7.466 ns (0 allocations: 0 bytes)
    # 16.868 ns (0 allocations: 0 bytes)
    # 16.867 ns (0 allocations: 0 bytes)
    # 5.208 ns (0 allocations: 0 bytes)
    #@btime BioLab.Statistics.get_quantile($cu)

end

# ---- #

for (po, re) in zip(
    0:4,
    (NaN, 0.6189908521765288, 0.1900545163940193, 0.06362492851958153, 0.019426335022525613),
)

    seed!(20230612)

    sa_ = randn(10^po)

    @test isequal(BioLab.Statistics.get_margin_of_error(sa_), re)

    # 24.946 ns (0 allocations: 0 bytes)
    # 31.475 ns (0 allocations: 0 bytes)
    # 60.177 ns (0 allocations: 0 bytes)
    # 537.476 ns (0 allocations: 0 bytes)
    # 3.969 μs (0 allocations: 0 bytes)
    #@btime BioLab.Statistics.get_margin_of_error($sa_)

end

# ---- #

seed!(20230612)

# ---- #

const SA_ = randn(1000)

# ---- #

for (co, re) in zip(
    (0, 0.001, 0.5, 0.95, 1),
    (0.0, 4.0685463561927655e-5, 0.021895485060908795, 0.06362492851958153, Inf),
)

    @test BioLab.Statistics.get_margin_of_error(SA_, co) === re

    # 527.267 ns (0 allocations: 0 bytes)
    # 526.393 ns (0 allocations: 0 bytes)
    # 526.398 ns (0 allocations: 0 bytes)
    # 537.476 ns (0 allocations: 0 bytes)
    # 521.597 ns (0 allocations: 0 bytes)
    #@btime BioLab.Statistics.get_margin_of_error(SA_, $co)

end

# ---- #

@test isone(BioLab.Statistics.get_p_value(1, 0))

# ---- #

const N_RA = 10

# ---- #

for (n_si, re) in ((0, 0.1), (1, 0.1), (2, 0.2))

    @test BioLab.Statistics.get_p_value(n_si, N_RA) === re

    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.458 ns (0 allocations: 0 bytes)
    #@btime BioLab.Statistics.get_p_value($n_si, N_RA)

end

# ---- #

const NU_ = [-1, -0.0, 0, 1]

# ---- #

const EM_ = Vector{Float64}()

# ---- #

const ON_ = ones(lastindex(NU_))

# ---- #

for fu in (<=, >=)

    @test BioLab.Statistics.get_p_value(fu, NU_, EM_) == (ON_, ON_)

    # 162.996 ns (6 allocations: 512 bytes)
    # 162.854 ns (6 allocations: 512 bytes)
    #@btime BioLab.Statistics.get_p_value($fu, NU_, EM_)

end

# ---- #

const RA_ = [-3, -2, -1, -0.0, 0, 1, 2, 3]

# ---- #

const REP1_, REA1_ = [0.375, 0.625, 0.625, 0.75], [0.75, 0.75, 0.75, 0.75]

# ---- #

for (fu, re) in ((<=, (REP1_, REA1_)), (>=, (reverse(REP1_), reverse(REA1_))))

    @test BioLab.Statistics.get_p_value(fu, NU_, RA_) == re

    # 178.959 ns (6 allocations: 512 bytes)
    # 185.096 ns (6 allocations: 512 bytes)
    #@btime BioLab.Statistics.get_p_value($fu, NU_, RA_)

end

# ---- #

const FE_X_ID_X_RA = reshape(RA_, :, 2)

# ---- #

const IDN_ = findall(BioLab.Number.is_negative, NU_)

# ---- #

const IDP_ = findall(BioLab.Number.is_positive, NU_)

# ---- #

const REP2_, REA2_ = [0.75, 1], [1.0, 1]

# ---- #

@test BioLab.Statistics.get_p_value(NU_, IDN_, IDP_, FE_X_ID_X_RA) ==
      (REP2_, REA2_, reverse(REP2_), reverse(REA2_))

# ---- #

# 447.601 ns (17 allocations: 1.27 KiB)
#@btime BioLab.Statistics.get_p_value(NU_, IDN_, IDP_, FE_X_ID_X_RA);
