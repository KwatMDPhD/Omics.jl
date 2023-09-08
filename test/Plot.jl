using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "Plot")

@test BioLab.Path.read(DA) == ["1.png", "2.png"]

# ---- #

const DATA = [Dict{String, Any}()]

const LAYOUT = Dict(
    "title" => "Title",
    "yaxis" => Dict("title" => "Y-Axis Title"),
    "xaxis" => Dict("title" => "X-Axis Title"),
)

# ---- #

BioLab.Plot.plot("", DATA)

# ---- #

BioLab.Plot.plot("", DATA, LAYOUT)

# ---- #

BioLab.Plot.plot(
    joinpath(BioLab.TE, "editable.html"),
    DATA,
    LAYOUT;
    config = Dict("editable" => true),
)

# ---- #

const SCY_ = [[-1, 0, 2], [3, 4]]

# ---- #

const HE = "#20d9ba"

BioLab.Plot.plot_scatter(
    "",
    SCY_;
    marker_ = (
        Dict("size" => 40, "color" => HE),
        Dict("size" => 20, "color" => BioLab.Plot.add_alpha(HE, 0.5)),
    ),
)

# ---- #

BioLab.Plot.plot_scatter("", SCY_, SCY_ * 10)

# ---- #

const BAY_ = [[-1, 2, 5], [5, 2, -1], [8]]

# ---- #

BioLab.Plot.plot_bar("", BAY_)

# ---- #

BioLab.Plot.plot_bar(
    "",
    BAY_,
    [[-2, -1, 0], [-2, -1, 0], [1]];
    name_ = ["Jonathan", "Joseph", "Jotaro"],
    layout = Dict("barmode" => "group", "title" => Dict("text" => "barmode = group")),
)

# ---- #

const HIX_ = [[-1], [0, 1], [2, 3, 4]]

# ---- #

BioLab.Plot.plot_histogram("", HIX_)

# ---- #

for xbins_size in (0, 1)

    BioLab.Plot.plot_histogram(
        "",
        HIX_,
        [["1A"], ["2A", "2B"], ["3A", "3B", "3C"]];
        xbins_size,
        layout = Dict("title" => Dict("text" => "xbins_size = $xbins_size")),
    )

end

# ---- #

const Z = BioLab.Simulation.make_matrix_1n(2, 4, Float64)

# ---- #

BioLab.Plot.plot_heat_map("", Z)

# ---- #

BioLab.Plot.plot_heat_map(
    "",
    Z,
    ["Row $id" for id in 1:size(Z, 1)],
    ["Column $id" for is in 1:size(Z, 2)],
)

# ---- #

const Y2 = [-1.0, 1, -2, 2]

const X2 = [1.0, 4, 2, 5, 3, 6]

const Z2 = [y * x for y in Y2, x in X2]

# ---- #

const GRR_ = [1, 2, 1, 2]

# ---- #

BioLab.Plot.plot_heat_map("", Z2; grr_ = GRR_)

# ---- #

const GRC_ = [1, 2, 1, 2, 1, 2]

# ---- #

BioLab.Plot.plot_heat_map("", Z2; grc_ = GRC_)

# ---- #

BioLab.Plot.plot_heat_map(
    "",
    Z2,
    ["Y = $nu" for nu in Y2],
    ["X = $nu" for nu in X2],
    grr_ = GRR_,
    grc_ = GRC_,
)

# ---- #

const THETA30 = collect(0:30:360)

const THETA45 = collect(0:45:360)

const THETA60 = collect(0:60:360)

BioLab.Plot.plot_radar(
    "",
    [THETA30, THETA45, THETA60],
    [eachindex(THETA30), eachindex(THETA45), eachindex(THETA60)];
    name_ = [30, 45, 60],
    layout = Dict("title" => Dict("text" => "Title Text")),
)

# ---- #

const GI = joinpath(BioLab.TE, "animate.gif")

@test BioLab.Plot.animate(GI, (joinpath(DA, "$pn.png") for pn in 1:2)) == GI
