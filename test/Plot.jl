using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

# 2.083 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
# 2.084 ns (0 allocations: 0 bytes)
for (mi, ma, ex, re) in
    ((0, 1, 0.1, (-0.1, 1.1)), (-1, 1, 0.1, (-1.2, 1.2)), (900, 1000, 0.1, (890.0, 1010.0)))

    @test Omics.Plot.rang(mi, ma, ex) === re

    #@btime Omics.Plot.rang($mi, $ma, $ex)

end

# ---- #

Omics.Plot.plot(
    "",
    (Dict("y" => (1, 2), "x" => (3, 4)),),
    Dict(
        "title" => "Title",
        "yaxis" => Dict("title" => Dict("text" => "Y-Axis Title")),
        "xaxis" => Dict("title" => Dict("text" => "X-Axis Title")),
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

# ---- #

Omics.Plot.animate(
    joinpath(tempdir(), "animate.gif"),
    (pkgdir(Omics, "data", "Plot", "$id.png") for id in 1:2),
)
