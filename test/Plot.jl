using Test: @test

using Nucleus

# ---- #

const DA = joinpath(Nucleus._DA, "Plot")

# ---- #

@test Nucleus.Path.read(DA) == ["1.png", "2.png"]

# ---- #

const DATA = [Dict{String, Any}()]

# ---- #

const HT = joinpath(Nucleus.TE, "plot.html")

# ---- #

Nucleus.Plot.plot(HT, DATA)

# ---- #

@test isfile(HT)

# ---- #

const LAYOUT = Dict(
    "title" => "Title",
    "xaxis" => Dict("title" => "X-Axis Title"),
    "yaxis" => Dict("title" => "Y-Axis Title"),
)

# ---- #

Nucleus.Plot.plot("", DATA, LAYOUT)

# ---- #

Nucleus.Plot.plot("", DATA, LAYOUT, Dict("editable" => true))

# ---- #

const HX_ = ([-2], [-1, -1, 0, 0], [1, 1, 1, 2, 2, 2, 3, 3, 3])

# ---- #

Nucleus.Plot.plot_histogram("", HX_[1:1])

# ---- #

Nucleus.Plot.plot_histogram("", HX_)

# ---- #

for xbins_size in (0, 1)

    Nucleus.Plot.plot_histogram(
        "",
        HX_,
        Tuple((id -> "$ch$id").(eachindex(x)) for (x, ch) in zip(HX_, ('A', 'B', 'C')));
        xbins_size,
        layout = Dict("title" => Dict("text" => "xbins_size = $xbins_size")),
    )

end

# ---- #

const Z = Nucleus.Simulation.make_matrix_1n(Float64, 2, 4)

# ---- #

const LA_ = String[]

# ---- #

const Y = (id -> "Row $id").(1:size(Z, 1))

# ---- #

const X = (id -> "Column $id").(1:size(Z, 2))

# ---- #

for (y, x) in ((LA_, LA_), (Y, LA_), (LA_, X), (Y, X))

    Nucleus.Plot.plot_heat_map("", Z; y, x)

end

# ---- #

const YG = collect(1.0:8)

# ---- #

const XG = collect(1.0:10)

# ---- #

const ZG = [y * x for y in YG, x in XG]

# ---- #

const THETA30 = 0:30:360

# ---- #

const THETA45 = 0:45:360

# ---- #

const THETA60 = 0:60:360

# ---- #

Nucleus.Plot.plot_radar(
    "",
    (THETA30, THETA45, THETA60),
    (eachindex(THETA30), eachindex(THETA45), eachindex(THETA60));
    name_ = (30, 45, 60),
    layout = Dict("title" => Dict("text" => "Title Text")),
)

# ---- #

const GI = joinpath(Nucleus.TE, "animate.gif")

# ---- #

Nucleus.Plot.animate(GI, (joinpath(DA, "$pn.png") for pn in 1:2))

# ---- #

@test isfile(GI)
