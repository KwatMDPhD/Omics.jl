using Plot

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using LeMoColor

# ---- #

const DA = pkgdir(Plot, "data")

Plot.animate(
    joinpath(tempdir(), "animate.gif"),
    (joinpath(DA, "1.png"), joinpath(DA, "2.png")),
)

# ---- #

Plot.plot(
    "",
    (Dict("y" => (1, 2), "x" => (3, 4)),),
    Dict(
        "title" => "Title",
        "yaxis" => Dict("title" => "Y-Axis Title"),
        "xaxis" => Dict("title" => "X-Axis Title"),
    ),
    Dict("editable" => true),
)

# ---- #

const MA = [
    0.999 3 5
    2 4 6.001
]

# ---- #

const RO_ = ("Aa", "Bb")

# ---- #

const CO_ = ("Cc", "Dd", "Ee")

# ---- #

Plot.plot_heat_map("", MA; ro_ = RO_, co_ = CO_)

# ---- #

Plot.plot_bubble_map("", MA * 40, MA; ro_ = RO_, co_ = CO_)

# ---- #

Plot.plot_bubble_map("", MA * 40, reverse(MA); ro_ = RO_, co_ = CO_)

# ---- #

for (na, co) in (
    ("Monary", LeMoColor.MO),
    ("Binary", LeMoColor.BI),
    ("Categorical", LeMoColor.CA),
    ("Continuous", LeMoColor.bwr),
)

    Plot.plot_heat_map(
        joinpath(tempdir(), "$na.html"),
        [id for _ in 1:1, id in eachindex(co.colors)];
        co_ = map(rg -> "_$(LeMoColor._hexify(rg))", co.colors),
        co,
        la = Dict("title" => na, "yaxis" => Dict("tickvals" => ())),
    )

end

# ---- #

const T3_ = 0:30:360

const T4 = 0:45:360

const T6 = 0:60:360

Plot.plot_radar(
    "",
    (T3_, T4, T6),
    (eachindex(T3_), eachindex(T4), eachindex(T6));
    na_ = (30, 45, 60),
    la = Dict("title" => Dict("text" => "Title Text")),
)
