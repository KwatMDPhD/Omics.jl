using ColorSchemes

using Colors

include("_.jl")

# --------------------------------------------- #

te = joinpath(tempdir(), "BioLab.test.Plot")

BioLab.Path.empty(te)

# --------------------------------------------- #

he_ = ("#ff71fb", "#fcc9b9", "#c91f37")

# TODO: `@test`.
display(BioLab.Plot._make_color_scheme(he_))

# @code_warntype BioLab.Plot._make_color_scheme(he_)

# 1.025 μs (21 allocations: 992 bytes)
# @btime BioLab.Plot._make_color_scheme($he_)

# --------------------------------------------- #

co_ = (
    BioLab.Plot.COPLA,
    BioLab.Plot.COPL3,
    BioLab.Plot.COPLO,
    BioLab.Plot.COBIN,
    BioLab.Plot.COASP,
    BioLab.Plot.COHUM,
    BioLab.Plot.COSTA,
    BioLab.Plot.COGUA,
    #BioLab.Plot.COAYA,
)

for co in co_

    display(co)

end

co = co_[1]

for nu in (-10.0^3, -1.0, -1, 0.0, 0, 0.5, 1.0, 1, 2.0, 2, 3.0, 3, 256.0, 256, 257)

    display(nu)

    try

        display(co[nu])

    catch er

        display(er)

    end

end

# --------------------------------------------- #

for nu in (0.0, 0.3, 0.6, 1, 2, 4, 8, 16, 32, 64, 128, 256)

    BioLab.print_header(nu)

    co1 = ColorSchemes.plasma[nu]

    co2 = parse(Colorant, BioLab.Plot.color(co, nu))

    println(co1)

    println(co2)

    display([co1, co2])

end

for nu in (0.2, 20)

    # @code_warntype BioLab.Plot.color(co, nu)

    # 95.671 ns (3 allocations: 112 bytes)
    # 87.760 ns (3 allocations: 112 bytes)
    # @btime BioLab.Plot.color($co, $nu)

end

# --------------------------------------------- #

for co in co_

    BioLab.print_header()

    # TODO: `@test`.
    display(BioLab.Plot.fractionate(co))

end

# @code_warntype BioLab.Plot.fractionate(co)

# 19.334 μs (769 allocations: 32.12 KiB)
# @btime BioLab.Plot.fractionate($co)

# --------------------------------------------- #

data = [Dict()]

BioLab.Plot.plot(data)

layout = Dict(
    "title" => "Title",
    "yaxis" => Dict("title" => "Y-Axis Title"),
    "xaxis" => Dict("title" => "X-Axis Title"),
)

BioLab.Plot.plot(data, layout)

config = Dict("editable" => true)

ht = joinpath(te, "plot.html")

BioLab.Plot.plot(data, layout; config, ht)

# @code_warntype BioLab.Plot.plot(data, layout; config, ht)

# --------------------------------------------- #

y1 = [-1, 0, 2]

y2 = [3, 4]

y_ = [y1, y2]

BioLab.Plot.plot_scatter(y_)

x_ = [y1 * 10, y2 * 20]

ht = joinpath(te, "scatter.html")

BioLab.Plot.plot_scatter(y_, x_; ht)

# @code_warntype BioLab.Plot.plot_scatter(y_, x_; ht)

# --------------------------------------------- #

y1 = [-1, 2, 5]

y_ = [y1, reverse(y1), [8]]

BioLab.Plot.plot_bar(y_)

x1 = [-2, -1, 0]

x_ = [x1, -x1, [0]]

name_ = ["Jonathan", "Joseph", "Jotaro"]

barmode = "group"

layout = Dict("barmode" => barmode, "title" => Dict("text" => titlecase(barmode)))

ht = joinpath(te, "bar.$barmode.html")

BioLab.Plot.plot_bar(y_, x_; name_, layout, ht)

# @code_warntype BioLab.Plot.plot_bar(y_, x_; name_, layout, ht)

# --------------------------------------------- #

x_ = [[-1], [0, 1], [2, 3, 4]]

BioLab.Plot.plot_histogram(x_)

text_ = [["1A"], ["2A", "2B"], ["3A", "3B", "3C"]]

for xbins_size in (0.0, 1.0)

    BioLab.Plot.plot_histogram(
        x_,
        text_;
        xbins_size,
        layout = Dict("title" => Dict("text" => xbins_size)),
    )

end

# @code_warntype BioLab.Plot.plot_histogram(x_, text_; ht = joinpath(te, "histogram.html"))

# --------------------------------------------- #

n_ro = 2

n_co = 4

ro1_x_co1_x_nu = convert(Matrix{Int}, BioLab.Matrix.simulate(n_ro, n_co, "1.0:"))

BioLab.Plot.plot_heat_map(ro1_x_co1_x_nu)

ro_ = ["Row$id" for id in 1:n_ro]

co_ = ["Column$id" for id in 1:n_co]

BioLab.Plot.plot_heat_map(ro1_x_co1_x_nu, ro_, co_)

y = [-1, 1, -2, 2]

x = [1, 4, 2, 5, 3, 6]

ro_x_co_x_nu = [la1 * la2 for la1 in y, la2 in x]

grr_ = [1, 2, 1, 2]

BioLab.Plot.plot_heat_map(ro_x_co_x_nu; grr_)

grc_ = [1, 2, 1, 2, 1, 2]

BioLab.Plot.plot_heat_map(ro_x_co_x_nu; grc_)

y = ["*$nu" for nu in y]

x = ["*$nu" for nu in x]

ht = joinpath(te, "heat_map.html")

BioLab.Plot.plot_heat_map(ro_x_co_x_nu, y, x; grr_, grc_, ht)

# @code_warntype BioLab.Plot.plot_heat_map(ro_x_co_x_nu, y, x; grr_, grc_, ht)

# --------------------------------------------- #

da = BioLab.DataFrame.make("Row name", ro_, co_, ro1_x_co1_x_nu)

ht = joinpath(te, "heat_map.data_frame.html")

BioLab.Plot.plot_heat_map(da; ht)

# @code_warntype BioLab.Plot.plot_heat_map(da; ht)

# --------------------------------------------- #

theta30 = collect(0:30:360)

theta45 = collect(0:45:360)

theta60 = collect(0:60:360)

theta_ = [theta30, theta45, theta60]

r___ = [theta30, theta45, theta60]

name_ = [30, 45, 60]

ht = joinpath(te, "radar.html")

BioLab.Plot.plot_radar(theta_, r___; name_, ht)

# @code_warntype BioLab.Plot.plot_radar(theta_, r___; name_, ht)
