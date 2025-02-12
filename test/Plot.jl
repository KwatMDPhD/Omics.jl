using Test: @test

using Omics

# ---- #

Omics.Plot.plot(
    "",
    (Dict("y" => (-1, 2), "x" => (-2, 4)),),
    Dict(
        "title" => Dict("text" => "Title"),
        "yaxis" => Dict("title" => Dict("text" => "Y-Axis Title")),
        "xaxis" => Dict("title" => Dict("text" => "X-Axis Title")),
    ),
)

# ---- #

const NU = [
    0.999 3 5
    2 4 6.001
]

const yc_ = ("Aa", "Bb")

const xc_ = ("Cc", "Dd", "Ee")

# ---- #

Omics.Plot.plot_heat_map("", NU; yc_, xc_)

# ---- #

Omics.Plot.plot_bubble_map("", reverse(NU) * 40, NU; yc_, xc_)

# ---- #

const A1_ = 0:30:360

const A2_ = 0:45:360

const A3_ = 0:60:360

Omics.Plot.plot_radar(
    "",
    (A1_, A2_, A3_),
    (eachindex(A1_), eachindex(A2_), eachindex(A3_));
    na_ = (30, 45, 60),
    la = Dict(
        "title" => Dict("text" => "Title Text"),
        "polar" => Dict("radialaxis" => Dict("range" => (0, 16))),
    ),
)
