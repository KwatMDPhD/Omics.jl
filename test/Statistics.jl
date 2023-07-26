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
