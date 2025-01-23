using Test: @test

using Omics

# ---- #

for (mi, ma, ex, re) in
    ((0, 1, 0.1, (-0.1, 1.1)), (-1, 1, 0.1, (-1.2, 1.2)), (900, 1000, 0.1, (890.0, 1010.0)))

    @test Omics.Plot.rang(mi, ma, ex) === re

end

# ---- #

Omics.Plot.plot(
    "",
    (Dict("y" => (1, 2), "x" => (3, 4)),),
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

const RO_ = ("Aa", "Bb")

const CO_ = ("Cc", "Dd", "Ee")

# ---- #

Omics.Plot.plot_heat_map("", NU; ro_ = RO_, co_ = CO_)

# ---- #

Omics.Plot.plot_bubble_map("", NU * 40, NU; ro_ = RO_, co_ = CO_)

Omics.Plot.plot_bubble_map("", NU * 40, reverse(NU); ro_ = RO_, co_ = CO_)

# ---- #

const A3_ = 0:30:360

const A4_ = 0:45:360

const A6_ = 0:60:360

Omics.Plot.plot_radar(
    "",
    (A3_, A4_, A6_),
    (eachindex(A3_), eachindex(A4_), eachindex(A6_));
    na_ = (30, 45, 60),
    la = Dict("title" => Dict("text" => "Title Text")),
)

# ---- #

Omics.Plot.animate(
    joinpath(tempdir(), "animate.gif"),
    (pkgdir(Omics, "data", "Plot", "$id.png") for id in 1:2),
)
