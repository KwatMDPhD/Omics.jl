include("_.jl")

# ---- #

fr_ = (0.0, 0.001, 0.025, 0.05, 0.5, 0.95, 0.975, 0.999, 1)

atol = 0.01

for (cu, re) in zip(fr_, (-Inf, -3.09, -1.96, -1.64, 0.0, 1.64, 1.96, 3.09, Inf))

    BioLab.print_header(cu)

    @test isapprox(BioLab.Statistics.get_z_score(cu), re; atol)

    # @code_warntype BioLab.Statistics.get_z_score(cu)

    # 4.916 ns (0 allocations: 0 bytes)
    # 11.386 ns (0 allocations: 0 bytes)
    # 11.386 ns (0 allocations: 0 bytes)
    # 7.716 ns (0 allocations: 0 bytes)
    # 7.382 ns (0 allocations: 0 bytes)
    # 7.674 ns (0 allocations: 0 bytes)
    # 16.449 ns (0 allocations: 0 bytes)
    # 16.491 ns (0 allocations: 0 bytes)
    # 6.458 ns (0 allocations: 0 bytes)
    # @btime BioLab.Statistics.get_z_score($cu)

end

# ---- #

for (co, re) in zip(
    fr_,
    (
        (-0.0, 0.0),
        (-0.001253314465432556, 0.0012533144654324167),
        (-0.03133798202142661, 0.031337982021426465),
        (-0.06270677794321385, 0.06270677794321385),
        (-0.6744897501960818, 0.6744897501960818),
        (-1.9599639845400576, 1.9599639845400576),
        (-2.2414027276049495, 2.2414027276049517),
        (-3.290526731491899, 3.290526731491931),
        (-Inf, Inf),
    ),
)

    BioLab.print_header(co)

    @test BioLab.Statistics.get_confidence_interval(co) == re

    # @code_warntype BioLab.Statistics.get_confidence_interval(co)

    # 16.658 ns (0 allocations: 0 bytes)
    # 16.616 ns (0 allocations: 0 bytes)
    # 16.616 ns (0 allocations: 0 bytes)
    # 16.658 ns (0 allocations: 0 bytes)
    # 16.658 ns (0 allocations: 0 bytes)
    # 30.601 ns (0 allocations: 0 bytes)
    # 30.570 ns (0 allocations: 0 bytes)
    # 30.600 ns (0 allocations: 0 bytes)
    # 12.179 ns (0 allocations: 0 bytes)
    # @btime BioLab.Statistics.get_confidence_interval($co)

end
