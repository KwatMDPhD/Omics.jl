using ColorSchemes

using Colors

include("environment.jl")

# ---- #

@test @is_error BioLab.Plot._make_color_scheme(("#012345",), "Category", "Notes")

# ---- #

he_ = ("#ff71fb", "#fcc9b9", "#c91f37")

ca = "Category"

no = "Notes"

co = BioLab.Plot._make_color_scheme(he_, ca, no)

@test length(co) == length(he_)

@test co.category == ca

@test co.notes == no

# ---- #

@test BioLab.Plot._CO == "continuous"

@test BioLab.Plot._CA == "categorical"

@test BioLab.Plot._BI == "binary"

# ---- #

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
)

    n = length(co)

    BioLab.Plot.plot_heat_map(
        permutedims(collect(1:n)),
        [],
        1:n,
        permutedims(map(BioLab.Plot._make_hex, co.colors));
        colorscale = BioLab.Plot.fractionate(co),
        layout = Dict("title" => Dict("text" => "$(co.category) $(co.notes).")),
    )

end

@test BioLab.Plot.COBWR.colors == ColorSchemes.bwr.colors

@test BioLab.Plot.COPLA.colors == ColorSchemes.plasma.colors

# ---- #

n = length(BioLab.Plot.COBWR)

# ---- #

for nu in (NaN, -1, 0, n + 1)

    @test @is_error BioLab.Plot.COBWR[nu]

end

# ---- #

for nu in (-Inf, -1.0, 0.0, 0.5, 1.0, 1, 2.0, 2, 3.0, 3, n, convert(Float64, n + 1), Inf)

    BioLab.Plot.COBWR[nu]

end

# ---- #

for (rg, re) in ((RGB(1, 0, 0), "#ff0000"), (RGB(0, 1, 0), "#00ff00"), (RGB(0, 0, 1), "#0000ff"))

    @test BioLab.Plot._make_hex(rg) == re

end

# ---- #

co = BioLab.Plot.COGUA

@test @is_error BioLab.Plot.color(co, 0)

for (nu, re) in (
    (-0.1, "#20d9ba"),
    (0.0, "#20d9ba"),
    (1, "#20d9ba"),
    (0.01, "#23d3bb"),
    (2, "#9017e6"),
    (3, "#4e40d8"),
    (0.99, "#fa1a6b"),
    (4, "#ff1968"),
    (1.0, "#ff1968"),
    (1.1, "#ff1968"),
)

    @test BioLab.Plot.color(co, nu) == re

end

@test @is_error BioLab.Plot.color(co, 5)

# ---- #

for (he_, re) in (
    (("#000000", "#ffffff"), (0, 1)),
    (("#ff0000", "#00ff00", "#0000ff"), (0, 0.5, 1)),
    (("#ff0000", "#00ff00", "#0000ff", "#f0000f"), (0, 1 / 3, 2 / 3, 1)),
    (("#ff0000", "#00ff00", "#0000ff", "#f0000f", "#0f00f0"), (0, 0.25, 0.5, 0.75, 1)),
    (
        ("#ff0000", "#00ff00", "#0000ff", "#f0000f", "#0f00f0", "#00ff00"),
        (0, 0.2, 0.4, 0.6, 0.8, 1),
    ),
)

    @test all(
        fr == re[id] && he == he_[id] for (id, (fr, he)) in
        enumerate(BioLab.Plot.fractionate(BioLab.Plot._make_color_scheme(he_, ca, no)))
    )

end

# ---- #

data = [Dict()]

BioLab.Plot.plot(data)

# ---- #

layout = Dict(
    "title" => "Title",
    "yaxis" => Dict("title" => "Y-Axis Title"),
    "xaxis" => Dict("title" => "X-Axis Title"),
)

BioLab.Plot.plot(data, layout)

# ---- #

te = joinpath(tempdir(), "BioLab.test.Plot")

BioLab.Path.reset(te)

BioLab.Plot.plot(data, layout; config = Dict("editable" => true), ht = joinpath(te, "plot.html"))

# ---- #

y1 = [-1, 0, 2]

y2 = [3, 4]

y_ = [y1, y2]

# ---- #

BioLab.Plot.plot_scatter(y_)

# ---- #

BioLab.Plot.plot_scatter(y_, [y1 * 10, y2 * 10])

# ---- #

y1 = [-1, 2, 5]

y_ = [y1, reverse(y1), [8]]

# ---- #

BioLab.Plot.plot_bar(y_)

# ---- #

x1 = [-2, -1, 0]

BioLab.Plot.plot_bar(
    y_,
    [x1, -x1, [0]];
    name_ = ["Jonathan", "Joseph", "Jotaro"],
    layout = Dict("barmode" => "group", "title" => Dict("text" => "barmode = group")),
)

# ---- #

x_ = [[-1], [0, 1], [2, 3, 4]]

BioLab.Plot.plot_histogram(x_)

# ---- #

for xbins_size in (0, 1)

    BioLab.Plot.plot_histogram(
        x_,
        [["1A"], ["2A", "2B"], ["3A", "3B", "3C"]];
        xbins_size,
        layout = Dict("title" => Dict("text" => "xbins_size = $xbins_size")),
    )

end

# ---- #

n_ro = 2

n_co = 4

ro1_x_co1_x_nu = convert(Matrix, reshape(1:(n_ro * n_co), n_ro, n_co))

ro_ = ["Row$id" for id in 1:n_ro]

co_ = ["Column$id" for id in 1:n_co]

# ---- #

BioLab.Plot.plot_heat_map(ro1_x_co1_x_nu)

# ---- #

BioLab.Plot.plot_heat_map(ro1_x_co1_x_nu, ro_, co_)

# ---- #

BioLab.Plot.plot_heat_map(
    BioLab.DataFrame.make("Row Name", ro_, co_, ro1_x_co1_x_nu);
    layout = Dict("xaxis" => Dict("title" => Dict("text" => "Column Name"))),
)

# ---- #

y = [-1, 1, -2, 2]

x = [1, 4, 2, 5, 3, 6]

ro2_x_co2_x_nu = [la1 * la2 for la1 in y, la2 in x]

grr_ = [1, 2, 1, 2]

grc_ = [1, 2, 1, 2, 1, 2]

# ---- #

BioLab.Plot.plot_heat_map(ro2_x_co2_x_nu; grr_)

# ---- #

BioLab.Plot.plot_heat_map(ro2_x_co2_x_nu; grc_)

# ---- #

BioLab.Plot.plot_heat_map(
    ro2_x_co2_x_nu,
    ["Y = $nu" for nu in y],
    ["X = $nu" for nu in x];
    grr_,
    grc_,
)

# ---- #

theta30 = collect(0:30:360)

theta45 = collect(0:45:360)

theta60 = collect(0:60:360)

BioLab.Plot.plot_radar(
    [theta30, theta45, theta60],
    [theta30, theta45, theta60];
    name_ = [30, 45, 60],
)
