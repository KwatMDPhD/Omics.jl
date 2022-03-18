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
tr_ = [Dict()]

OnePiece.figure.view(OnePiece.figure.plot(tr_))

# ----------------------------------------------------------------------------------------------- #
OnePiece.figure.view

# ----------------------------------------------------------------------------------------------- #
la = Dict(
    "title" => "Title",
    "yaxis" => Dict("title" => "Y-Axis Title"),
    "xaxis" => Dict("title" => "X-Axis Title"),
)

OnePiece.figure.view(OnePiece.figure.plot(tr_, la))

OnePiece.figure.plot(tr_, ou = joinpath(TE, "output.html"))

# ----------------------------------------------------------------------------------------------- #
x1 = [-1, 0, 2]

x2 = [3, 4]

x_ = [x1, x2]

y1 = x1 .* 10

y2 = x2 .* 20

y_ = [y1, y2]

OnePiece.figure.view(OnePiece.figure.plot_x_y(y_))

OnePiece.figure.view(OnePiece.figure.plot_x_y(y_; la = la))

OnePiece.figure.view(OnePiece.figure.plot_x_y(y_, x_; la = la, ou = joinpath(TE, "x_y.html")))

# ----------------------------------------------------------------------------------------------- #
y1 = [-1, 2, 5]

y2 = reverse(y1)

y_ = [y1, y2]

OnePiece.figure.view(OnePiece.figure.plot_bar(y_))

OnePiece.figure.view(OnePiece.figure.plot_bar(y_; la = la))

# ----------------------------------------------------------------------------------------------- #
name1 = "Orange"

name2 = "Blue"

name_ = [name1, name2]

x1 = [-2, -1, 0]

x2 = .-reverse(x1)

x_ = [x1, x2]

OnePiece.figure.view(OnePiece.figure.plot_bar(y_, x_; name_ = name_, la = la))

push!(name_, "Name 3")

push!(y_, [9])

push!(x_, [0])

OnePiece.figure.view(OnePiece.figure.plot_bar(y_, x_; name_ = name_, la = la))

OnePiece.figure.view(
    OnePiece.figure.plot_bar(
        y_,
        x_;
        name_ = name_,
        la = Dict("barmode" => "stack"),
        ou = joinpath(TE, "bar.html"),
    ),
)

# ----------------------------------------------------------------------------------------------- #
ma = OnePiece.tensor.simulate(2, 4)

println(ma)

OnePiece.figure.view(
    OnePiece.figure.plot_heat_map(
        ma,
        ["Row$id" for id in 1:size(ma, 1)],
        ["Column$id" for id in 1:size(ma, 2)],
    ),
)

OnePiece.figure.view(OnePiece.figure.plot_heat_map(ma, ou = joinpath(TE, "heat_map.html")))

# ----------------------------------------------------------------------------------------------- #
println("Done.")
