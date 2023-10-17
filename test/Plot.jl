using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "Plot")

# ---- #

@test BioLab.Path.read(DA) == ["1.png", "2.png"]

# ---- #

const DATA = [Dict{String, Any}()]

# ---- #

BioLab.Plot.plot(joinpath(BioLab.TE, "plot.html"), DATA)

# ---- #

const LAYOUT = Dict(
    "title" => "Title",
    "yaxis" => Dict("title" => "Y-Axis Title"),
    "xaxis" => Dict("title" => "X-Axis Title"),
)

# ---- #

BioLab.Plot.plot("", DATA, LAYOUT)

# ---- #

BioLab.Plot.plot("", DATA, LAYOUT, Dict("editable" => true))

# ---- #

const Y_ = [[-2, -1], [-1, 0, 1, 2]]

# ---- #

BioLab.Plot.plot_scatter("", Y_[1:1])

# ---- #

BioLab.Plot.plot_scatter("", Y_)

# ---- #

BioLab.Plot.plot_scatter(
    "",
    Y_,
    Y_,
    marker_ = (Dict("size" => 80, "color" => "#ff0000"), Dict("size" => 40, "color" => "#0000ff")),
)

# ---- #

BioLab.Plot.plot_bar("", Y_[1:1])

# ---- #

BioLab.Plot.plot_bar("", Y_)

# ---- #

for barmode in ("group", "stack")

    BioLab.Plot.plot_bar(
        "",
        Y_,
        Y_;
        name_ = ["Jonathan", "Joseph", "Jotaro"],
        layout = Dict("barmode" => barmode, "title" => Dict("text" => "barmode = $barmode")),
    )

end

# ---- #

const HIX_ = [[-2], [-1, -1, 0, 0], [1, 1, 1, 2, 2, 2, 3, 3, 3]]

# ---- #

BioLab.Plot.plot_histogram("", HIX_[1:1])

# ---- #

BioLab.Plot.plot_histogram("", HIX_)

# ---- #

for xbins_size in (0, 1)

    BioLab.Plot.plot_histogram(
        "",
        HIX_,
        [["$ch$id" for id in eachindex(x)] for (x, ch) in zip(HIX_, ('A', 'B', 'C'))];
        xbins_size,
        layout = Dict("title" => Dict("text" => "xbins_size = $xbins_size")),
    )

end

# ---- #

const Z = BioLab.Simulation.make_matrix_1n(Float64, 2, 4)

# ---- #

const Y = (id -> "Row $id").(1:size(Z, 1))

# ---- #

const X = (id -> "Column $id").(1:size(Z, 2))

# ---- #

for (y, x) in (((), ()), (Y, ()), ((), X), (Y, X))

    BioLab.Plot.plot_heat_map("", Z; y, x)

end

# ---- #

const YG = collect(1.0:8)

# ---- #

const XG = collect(1.0:10)

# ---- #

const ZG = [y * x for y in YG, x in XG]

# ---- #

const GRR_ = [1, 2, 1, 2, 1, 2, 1, 2]

# ---- #

const GRC_ = [1, 2, 1, 2, 1, 2, 1, 2, 1, 2]

# ---- #

for (grr_, grc_) in (
    (GRR_, Vector{Int}()),
    (Vector{Int}(), GRC_),
    (GRR_, GRC_),
    ((id -> "Row Group $id").(GRR_), (id -> "Column Group $id").(GRC_)),
)

    BioLab.Plot.plot_heat_map(
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

BioLab.Plot.plot_radar(
    "",
    [eachindex(THETA30), eachindex(THETA45), eachindex(THETA60)],
    [THETA30, THETA45, THETA60];
    name_ = [30, 45, 60],
    layout = Dict("title" => Dict("text" => "Title Text")),
)

# ---- #

const GI = joinpath(BioLab.TE, "animate.gif")

# ---- #

BioLab.Plot.animate(GI, (joinpath(DA, "$pn.png") for pn in 1:2))

# ---- #

@test isfile(GI)
