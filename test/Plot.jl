using ColorSchemes: bwr, plasma

using Colors: RGB

using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "Plot")

# ---- #

@test readdir(DA) == ["1.png", "2.png"]

# ---- #

const HE_ = ("#ff71fb", "#fcc9b9", "#c91f37")

# ---- #

const CO = BioLab.Plot._make_color_scheme(HE_)

@test length(CO) == length(HE_)

# ---- #

@test BioLab.Plot.COBWR == bwr

@test BioLab.Plot.COPLA == plasma

# ---- #

for co in (
    BioLab.Plot.COBWR,
    BioLab.Plot.COPLA,
    BioLab.Plot.COPL3,
    BioLab.Plot.COASP,
    BioLab.Plot.COPLO,
    BioLab.Plot.COBIN,
    BioLab.Plot.COHUM,
    BioLab.Plot.COSTA,
    BioLab.Plot.COMON,
)

    BioLab.Plot.plot_heat_map(
        "",
        [x for _ in 1:1, x in 1:length(co)];
        text = [BioLab.Plot._make_hex(cl) for _ in 1:1, cl in co.colors],
        colorscale = BioLab.Plot.map_fraction_to_color(co),
        layout = Dict("yaxis" => Dict("tickvals" => ()), "xaxis" => Dict("dtick" => 1)),
    )

end

# ---- #

for (rg, re) in ((RGB(1, 0, 0), "#ff0000"), (RGB(0, 1, 0), "#00ff00"), (RGB(0, 0, 1), "#0000ff"))

    @test BioLab.Plot._make_hex(rg) == re

end

# ---- #

for (he_, fr_) in (
    (("#000000", "#ffffff"), (0, 1)),
    (("#ff0000", "#00ff00", "#0000ff"), (0, 0.5, 1)),
    (("#ff0000", "#00ff00", "#0000ff", "#f0000f"), (0, 1 / 3, 2 / 3, 1)),
    (("#ff0000", "#00ff00", "#0000ff", "#f0000f", "#0f00f0"), (0, 0.25, 0.5, 0.75, 1)),
    (
        ("#ff0000", "#00ff00", "#0000ff", "#f0000f", "#0f00f0", "#00ff00"),
        (0, 0.2, 0.4, 0.6, 0.8, 1),
    ),
)

    @test BioLab.Plot.map_fraction_to_color(BioLab.Plot._make_color_scheme(he_)) ==
          collect(zip(fr_, he_))

end

# ---- #

for (n, re) in (
    (0, BioLab.Plot.COMON),
    (1, BioLab.Plot.COMON),
    (2, BioLab.Plot.COBIN),
    (3, BioLab.Plot.COPLO),
)

    @test BioLab.Plot.pick_color_scheme(rand(n)) == BioLab.Plot.COBWR

    @test BioLab.Plot.pick_color_scheme(rand(Int, n)) == re

end

# ---- #

const N = length(CO)

# ---- #

for nu in (NaN, -1, 0, N + 1)

    @test BioLab.Error.@is_error CO[nu]

end

# ---- #

for (nu, re) in zip(
    (-Inf, -0.1, 0.0, 0.01, 0.99, 1.0, 1.1, Inf),
    ("#ff71fb", "#ff71fb", "#ff71fb", "#ff73fa", "#ca223a", "#c91f37", "#c91f37", "#c91f37"),
)

    @test BioLab.Plot.color(nu, CO) == re

end

# ---- #

const IT_ = [1, 2, N]

# ---- #

for (it, re) in zip(IT_, HE_)

    @test BioLab.Plot.color(it, CO) == re

end

@test BioLab.Plot.color(IT_, CO) == collect(HE_)

# ---- #

@test BioLab.Plot.color(vcat(IT_, N + 1), CO) == [HE_[1], "#fdaccf", "#eb908e", HE_[end]]

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

const SCY1 = [-1, 0, 2]

const SCY2 = [3, 4]

const SCY_ = [SCY1, SCY2]

# ---- #

BioLab.Plot.plot_scatter("", SCY_)

# ---- #

BioLab.Plot.plot_scatter("", SCY_, [SCY1 * 10, SCY2 * 10])

# ---- #

const BAY = [-1, 2, 5]

const BAY_ = [BAY, reverse(BAY), [8]]

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

const MA1 = BioLab.Simulation.make_matrix_1n(2, 4, Float64)

# ---- #

BioLab.Plot.plot_heat_map("", MA1)

# ---- #

BioLab.Plot.plot_heat_map(
    "",
    MA1,
    string.("Row ", 1:size(MA1, 1)),
    string.("Column ", 1:size(MA1, 2)),
)

# ---- #

const HEY = [-1.0, 1, -2, 2]

const HEX = [1.0, 4, 2, 5, 3, 6]

const MA2 = [y * x for y in HEY, x in HEX]

# ---- #

const GRR_ = [1, 2, 1, 2]

# ---- #

BioLab.Plot.plot_heat_map("", MA2; grr_ = GRR_)

# ---- #

const GRC_ = [1, 2, 1, 2, 1, 2]

# ---- #

BioLab.Plot.plot_heat_map("", MA2; grc_ = GRC_)

# ---- #

BioLab.Plot.plot_heat_map(
    "",
    MA2,
    string.("Y = ", HEY),
    string.("X = ", HEX);
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

BioLab.Plot.animate(joinpath(BioLab.TE, "animate.gif"), (joinpath(DA, "$pn.png") for pn in 1:2))
