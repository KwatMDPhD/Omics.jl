# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
ve = [-1, 0, 0, 1, 2]

;

OnePiece.informatics.tensor.get_extreme(ve)

OnePiece.informatics.tensor.get_extreme([-maximum(ve), ve...])

OnePiece.informatics.tensor.get_area([-1, 0, 1, 2])

OnePiece.informatics.tensor.get_area([-2, -1, 0, 0, 1, 2])

OnePiece.informatics.tensor.sum_where([0, 1, 2, 3], [0, 1, 0, 1])

ve = collect(-3:3)

;

for nu in ve

    println(OnePiece.informatics.tensor.shift_minimum(ve, nu))

end

OnePiece.informatics.tensor.shift_minimum(ve, "0<")

OnePiece.informatics.tensor.cumulate_sum_reverse(1:10)

for ic_ in [[0, 1, 2], [0, 1, 2, 0], [0, 1, 2, 2, 1, 0, 1, 2, 3]]

    println("-"^99)

    println(ic_)

    println(OnePiece.informatics.tensor.make_increasing_by_stepping_up!(copy(ic_)))

    println(OnePiece.informatics.tensor.make_increasing_by_stepping_down!(copy(ic_)))

end

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
