using ColorSchemes: bwr, plasma

using Colors: RGB

using Test: @test

using BioLab

# ---- #

DA = joinpath(BioLab.DA, "Plot")

@test readdir(DA) == ["1.png", "2.png"]

# ---- #

@test BioLab.Plot._CO == "continuous"

@test BioLab.Plot._CA == "categorical"

@test BioLab.Plot._BI == "binary"

@test BioLab.Plot._MO == "monotonous"

# ---- #

he_ = ("#ff71fb", "#fcc9b9", "#c91f37")

ca = "Category"

no = "Notes"

co = BioLab.Plot.make_color_scheme(he_, ca, no)

@test length(co) == length(he_)

@test co.category == ca

@test co.notes == no

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

    @test BioLab.Plot.fractionate(BioLab.Plot.make_color_scheme(he_, ca, no)) ==
          collect(zip(fr_, he_))

end

# ---- #

@test BioLab.Plot.COBWR.colors == bwr.colors

@test BioLab.Plot.COPLA.colors == plasma.colors

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

    n = length(co)

    ca = titlecase(co.category)

    no = co.notes

    BioLab.Plot.plot_heat_map(
        "",
        permutedims(collect(1:n)),
        Vector{String}(),
        1:n;
        text = permutedims(map(BioLab.Plot._make_hex, co.colors)),
        colorscale = BioLab.Plot.fractionate(co),
        layout = Dict("title" => Dict("text" => "$ca $no")),
    )

end

# ---- #

for (n, re) in (
    (0, COMON),
    (1, COMON),
    (2, COBIN),
    (3, COPLO),
    (19, COPLO),
    (20, COPLO),
    (21, COBWR),
    (99, COBWR),
)

    @test BioLab.Plot.pick_color_scheme(repeat(rand(n), 2)) == re

end

# ---- #

co = BioLab.Plot.COGUA

n = length(co)

# ---- #

for nu in (NaN, -1, 0, n + 1)

    @test @is_error co[nu]

end

nu_ = [-Inf, -0.1, 0.0, 1, 0.01, 2, 3, 0.99, n, 1.0, 1.1, convert(Float64, n + 1), Inf]

re_ = [
    "#20d9ba",
    "#20d9ba",
    "#20d9ba",
    "#20d9ba",
    "#23d3bb",
    "#9017e6",
    "#4e40d8",
    "#fa1a6b",
    "#ff1968",
    "#ff1968",
    "#ff1968",
    "#ff1968",
    "#ff1968",
]

for (nu, re) in zip(nu_, re_)

    @test BioLab.Plot.color(nu, co) == re

end

@test BioLab.Plot.color(nu_, co) == re_

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
