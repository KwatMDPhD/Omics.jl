using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

Omics.Plot.animate(
    joinpath(tempdir(), "animate.gif"),
    (pkgdir(Omics, "data", "Plot", "$id.png") for id in 1:2),
)

# ---- #

Omics.Plot.plot(
    "",
    (Dict("y" => (1, 2), "x" => (3, 4)),),
    Dict(
        "title" => "Title",
        "yaxis" => Dict("title" => "Y-Axis Title"),
        "xaxis" => Dict("title" => "X-Axis Title"),
    ),
)

# ---- #

const MA = [
    0.999 3 5
    2 4 6.001
]

const RO_ = ("Aa", "Bb")

const CO_ = ("Cc", "Dd", "Ee")

# ---- #

Omics.Plot.plot_heat_map("", MA; ro_ = RO_, co_ = CO_)

# ---- #

Omics.Plot.plot_bubble_map("", MA * 40, MA; ro_ = RO_, co_ = CO_)

Omics.Plot.plot_bubble_map("", MA * 40, reverse(MA); ro_ = RO_, co_ = CO_)

# ---- #

const T3_ = 0:30:360

const T4 = 0:45:360

const T6 = 0:60:360

Omics.Plot.plot_radar(
    "",
    (T3_, T4, T6),
    (eachindex(T3_), eachindex(T4), eachindex(T6));
    na_ = (30, 45, 60),
    la = Dict("title" => Dict("text" => "Title Text")),
)
