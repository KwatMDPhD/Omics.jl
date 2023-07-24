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

@test length(BioLab.Plot.make_color_scheme(HE_)) == length(HE_)

# ---- #

@test BioLab.Plot.COBWR == bwr

@test BioLab.Plot.COPLA == plasma

for co in (
    BioLab.Plot.COBWR,
    BioLab.Plot.COPLA,
    BioLab.Plot.COPL3,
    BioLab.Plot.COASP,
    BioLab.Plot.COPLO,
    BioLab.Plot.COGUA,
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

    @test BioLab.Plot.map_fraction_to_color(BioLab.Plot.make_color_scheme(he_)) ==
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

const CO = BioLab.Plot.COGUA

const N = length(CO)

for nu in (NaN, -1, 0, N + 1)

    @test BioLab.@is_error CO[nu]

end

for (nu, re) in zip(
    (-Inf, -0.1, 0.0, 0.01, 0.99, 1.0, 1.1, Inf),
    ("#20d9ba", "#20d9ba", "#20d9ba", "#23d3bb", "#fa1a6b", "#ff1968", "#ff1968", "#ff1968"),
)

    @test BioLab.Plot.color(nu, CO) == re

end

const IT_ = [1, 2, 3, N]

const RE_ = ["#20d9ba", "#9017e6", "#4e40d8", "#ff1968"]

for (it, re) in zip(IT_, RE_)

    @test BioLab.Plot.color(it, CO) == re

end

@test BioLab.Plot.color(IT_, CO) == RE_

@test BioLab.Plot.color(vcat(IT_, N + 1), CO) == [
    "#20d9ba"
    "#7448db"
    "#6f2cdf"
    "#7a36bc"
    "#ff1968"
]

# ---- #

data = [Dict()]

layout = Dict(
    "title" => "Title",
    "yaxis" => Dict("title" => "Y-Axis Title"),
    "xaxis" => Dict("title" => "X-Axis Title"),
)

BioLab.Plot.plot("", data)

BioLab.Plot.plot("", data, layout)

BioLab.Plot.plot(joinpath(TE, "plot.html"), data, layout; config = Dict("editable" => true))

# ---- #

it_ = collect(-1:9)

for n in 1:3

    @test collect(BioLab.Plot._range(it_, n)) == collect(-1:9)

end

# ---- #

fl_ = convert(Vector{Float64}, it_)

for (n, re) in ((1, [-1, 9]), (2, [-1, 4, 9]), (4, [-1, 1.5, 4, 6.5, 9]), (10, fl_))

    @test collect(BioLab.Plot._range(fl_, n)) == re

end

# ---- #

# TODO: Use missing.

for (z, re) in ((), (), ())

    @test BioLab.Plot.make_colorbar(z)

end

# ---- #

@test BioLab.Plot.make_axis() == Dict("zeroline" => false, "showgrid" => false)

# ---- #

@test BioLab.Plot.make_annotation() == Dict(
    "yref" => "paper",
    "xref" => "paper",
    "yanchor" => "middle",
    "showarrow" => false,
    "font" => Dict("size" => 10),
)

# ---- #

y1 = [-1, 0, 2]

y2 = [3, 4]

y_ = [y1, y2]

BioLab.Plot.plot_scatter("", y_)

BioLab.Plot.plot_scatter(y_, [y1 * 10, y2 * 10]; name_ = ("One", "Two"))

# ---- #

y1 = [-1, 2, 5]

y_ = [y1, reverse(y1), [8]]

x1 = [-2, -1, 0]

BioLab.Plot.plot_bar("", y_)

BioLab.Plot.plot_bar(
    "",
    y_,
    [x1, -x1, [0]];
    name_ = ["Jonathan", "Joseph", "Jotaro"],
    layout = Dict("barmode" => "group", "title" => Dict("text" => "barmode = group")),
)

# ---- #

x_ = [[-1], [0, 1], [2, 3, 4]]

BioLab.Plot.plot_histogram("", x_)

for xbins_size in (0, 1)

    BioLab.Plot.plot_histogram(
        "",
        x_,
        [["1A"], ["2A", "2B"], ["3A", "3B", "3C"]];
        xbins_size,
        layout = Dict("title" => Dict("text" => "xbins_size = $xbins_size")),
    )

end

# ---- #

n_ro = 2

n_co = 4

ma1 = convert(Matrix, reshape(1:(n_ro * n_co), n_ro, n_co))

ro_ = ["Row $id" for id in 1:n_ro]

co_ = ["Column $id" for id in 1:n_co]

BioLab.Plot.plot_heat_map("", ma1)

BioLab.Plot.plot_heat_map("", ma1, ro_, co_)

BioLab.Plot.plot_heat_map(
    "",
    BioLab.DataFrame.make("Row Name", ro_, co_, ma1);
    layout = Dict(
        "title" => Dict("text" => "Plotting DataFrame"),
        "xaxis" => Dict("title" => Dict("text" => "Column Name")),
    ),
)

y = [-1, 1, -2, 2]

x = [1, 4, 2, 5, 3, 6]

ma2 = [la1 * la2 for la1 in y, la2 in x]

grr_ = [1, 2, 1, 2]

grc_ = [1, 2, 1, 2, 1, 2]

BioLab.Plot.plot_heat_map("", ma2; grr_)

BioLab.Plot.plot_heat_map("", ma2; grc_)

BioLab.Plot.plot_heat_map("", ma2, ["Y = $nu" for nu in y], ["X = $nu" for nu in x]; grr_, grc_)

# ---- #

theta30 = collect(0:30:360)

theta45 = collect(0:45:360)

theta60 = collect(0:60:360)

theta_ = [theta30, theta45, theta60]

r_ = [1:length(theta30), 1:length(theta45), 1:length(theta60)]

BioLab.Plot.plot_radar("", theta_, r_; name_ = [30, 45, 60])

# ---- #

BioLab.Plot.animate(joinpath(TE, "animate.gif"), (joinpath(DA, "$pn.png") for pn in (1, 2)))
