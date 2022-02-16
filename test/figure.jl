# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "figure.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")


# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
using PlotlyLight

tr_ = [Dict()]

display(OnePiece.figure.plot(tr_))

la = Config(
    template = "plotly_dark",
    title = "Title",
    yaxis = Config(title = "Y-Axis Title"),
    xaxis = Config(title = "X-Axis Title"),
)

display(OnePiece.figure.plot(tr_, la))

co = Config(displaylog = true)

display(OnePiece.figure.plot(tr_, la, co))

display(OnePiece.figure.plot(tr_, ou = joinpath(TE, "output.html")))

pl = OnePiece.figure.plot(tr_)

OnePiece.figure.write(joinpath(tempdir(), "snow.png"), pl, 400, 200, 1.0)

x1 = [-1, 0, 2]

x2 = [3, 4]

x_ = [x1, x2]

y1 = x1 .* 10

y2 = x2 .* 20

y_ = [y1, y2]

;

display(OnePiece.figure.plot_x_y(y_))

display(OnePiece.figure.plot_x_y(y_; la = la))

display(OnePiece.figure.plot_x_y(y_, x_; la = la, ou = joinpath(TE, "x_y.html")))

y1 = [-1, 2, 5]

y2 = reverse(y1)

y_ = [y1, y2]

display(OnePiece.figure.plot_bar(y_))

display(OnePiece.figure.plot_bar(y_; la = la))

name1 = "Orange"

name2 = "Blue"
TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

name_ = [name1, name2]

x1 = [-2, -1, 0]

x2 = .-reverse(x1)

x_ = [x1, x2]

display(OnePiece.figure.plot_bar(y_, x_; name_ = name_, la = la))

push!(name_, "Name 3")

push!(y_, [9])

push!(x_, [0])

display(OnePiece.figure.plot_bar(y_, x_; name_ = name_, la = la))

display(
    OnePiece.figure.plot_bar(
        y_,
        x_;
        name_ = name_,
        la = Dict("barmode" => "stack"),
        ou = joinpath(TE, "bar.html"),
    ),
)

ma = convert(Matrix, reshape(1:8, (2, 4)))

display(
    OnePiece.figure.plot_heat_map(
        ma,
        [string("Row", id) for id in 1:size(ma, 1)],
        [string("Column", id) for id in 1:size(ma, 2)],
    ),
)

display(OnePiece.figure.plot_heat_map(ma, ou = joinpath(TE, "heat_map.html")))


# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
