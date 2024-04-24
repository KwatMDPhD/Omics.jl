using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

const NO_ = ["Node $id" for id in 1:6]

# ---- #

const D = [
    0 1 2 3 4 5
    1 0 3 4 5 6
    2 3 0 5 6 7
    3 4 5 0 7 8
    4 5 6 7 0 9
    5 6 7 8 9 0.0
]

# ---- #

Nucleus.Plot.plot_heat_map(
    joinpath(Nucleus.TE, "D.html"),
    D;
    y = NO_,
    x = NO_,
    layout = Dict("title" => Dict("text" => "Distance")),
)

# ---- #

seed!(20240423)

# ---- #

an_, ob_, te_, ac_ = Nucleus.Radar.anneal(D)

# ---- #

Nucleus.Radar.plot_annealing(joinpath(Nucleus.TE, "annealing.html"), ob_, te_, ac_)

# ---- #

Nucleus.Radar.plot_radar(joinpath(Nucleus.TE, "radar.html"), an_)

# ---- #

seed!(20240423)

# ---- #

# 108.833 μs (10 allocations: 17.09 KiB)
#@btime Nucleus.Radar.anneal(D);
