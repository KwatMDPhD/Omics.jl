using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

D = [
    0 1 2 3 4 5
    1 0 3 4 5 6
    2 3 0 5 6 7
    3 4 5 0 7 8
    4 5 6 7 0 9
    5 6 7 8 9 0.0
]

# ---- #

Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "D.html"), D)

# ---- #

seed!(20240423)

co_ = Nucleus.AngularScaling.scale(D, 1e-3, 0.5 * pi, 10^3; pl = true)

# ---- #

seed!(20240423)

# 39.875 μs (2 allocations: 480 bytes)
@btime Nucleus.AngularScaling.scale($D, 1e-3, 1e-1, 10^2)
