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
    "yaxis" => Dict("title" => "Y-Axis Title"),
    "xaxis" => Dict("title" => "X-Axis Title"),
)

# ---- #

Nucleus.Plot.plot("", DATA, LAYOUT)

# ---- #

Nucleus.Plot.plot("", DATA, LAYOUT, Dict("editable" => true))

# ---- #

const Y_ = ([-2, -1], [-1, 0, 1, 2])

# ---- #

const Y1_ = Y_[1:1]

# ---- #

Nucleus.Plot.plot_scatter("", Y1_)

# ---- #

Nucleus.Plot.plot_scatter("", Y_)

# ---- #

Nucleus.Plot.plot_scatter(
    "",
    Y_,
    Y_,
    marker_ = (Dict("size" => 80, "color" => "#ff0000"), Dict("size" => 40, "color" => "#0000ff")),
)

# ---- #

Nucleus.Plot.plot_bar("", Y1_)

# ---- #

Nucleus.Plot.plot_bar("", Y_)

# ---- #

for barmode in ("group", "stack")

    Nucleus.Plot.plot_bar(
        "",
        Y_,
        Y_;
        name_ = ("Jonathan", "Joseph", "Jotaro"),
        layout = Dict("barmode" => barmode, "title" => Dict("text" => "barmode = $barmode")),
    )

end

# ---- #

const HIX_ = ([-2], [-1, -1, 0, 0], [1, 1, 1, 2, 2, 2, 3, 3, 3])

# ---- #

Nucleus.Plot.plot_histogram("", HIX_[1:1])

# ---- #

Nucleus.Plot.plot_histogram("", HIX_)

# ---- #

for xbins_size in (0, 1)

    Nucleus.Plot.plot_histogram(
        "",
        HIX_,
        Tuple((id -> "$ch$id").(eachindex(x)) for (x, ch) in zip(HIX_, ('A', 'B', 'C')));
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

const GR_ = Int[]

# ---- #

const GRR_ = [1, 2, 1, 2, 1, 2, 1, 2]

# ---- #

const GRC_ = [1, 2, 1, 2, 1, 2, 1, 2, 1, 2]

# ---- #

for (grr_, grc_) in (
    (GRR_, GR_),
    (GR_, GRC_),
    (GRR_, GRC_),
    ((id -> "Row Group $id").(GRR_), (id -> "Column Group $id").(GRC_)),
)

    Nucleus.Plot.plot_heat_map(
        "",
        ZG;
        y = (nu -> "Y = $nu").(YG),
        x = (nu -> "X = $nu").(XG),
        grr_,
        grc_,
    )

end

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
