# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "tensor.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
println(OnePiece.tensor.simulate(2, 4))

# ----------------------------------------------------------------------------------------------- #
te = [-1, 0, 0, 1, 2]

# ----------------------------------------------------------------------------------------------- #
println(OnePiece.tensor.get_extreme(te))

println(OnePiece.tensor.get_extreme([-maximum(te), te...]))

# ----------------------------------------------------------------------------------------------- #
println(OnePiece.tensor.get_area([-1, 0, 1, 2]))

println(OnePiece.tensor.get_area([-2, -1, 0, 0, 1, 2]))

# ----------------------------------------------------------------------------------------------- #
te = collect(-3:3)

for nu in te

    println(OnePiece.tensor.shift_minimum(te, nu))

end

println(OnePiece.tensor.shift_minimum(te, "0<"))

# ----------------------------------------------------------------------------------------------- #
println(OnePiece.tensor.cumulate_sum_reverse(1:10))

# ----------------------------------------------------------------------------------------------- #
for ic_ in [[0, 1, 2], [0, 1, 2, 0], [0, 1, 2, 2, 1, 0, 1, 2, 3]]

    println("-"^99)

    println(ic_)

    println(OnePiece.tensor.make_increasing_by_stepping_up!(copy(ic_)))

    println(OnePiece.tensor.make_increasing_by_stepping_down!(copy(ic_)))

end

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
