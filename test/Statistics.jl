using Test: @test

using BioLab

# ---- #

const FR_ = (0, 0.001, 0.025, 0.05, 0.5, 0.95, 0.975, 0.999, 1)

# ---- #

for (cu, re) in zip(FR_, (-Inf, -3.09, -1.96, -1.64, 0, 1.64, 1.96, 3.09, Inf))

    @test isapprox(BioLab.Statistics.get_z_score(cu), re; atol = 1e-2)

end
