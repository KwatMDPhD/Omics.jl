# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "normalization.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
try

    OnePiece.normalization.normalize([], "0-1")

catch er

    println(er)

end

try

    OnePiece.normalization.normalize([-1, 0, 1], "sum")

catch er

    println(er)

end

for ve in [[0], [1], [0, 0, 0], [1, 1, 1], [0, 1, 2]]

    println(ve)

    for me in ["0-1", "sum", "-0-"]

        println(me)

        println(OnePiece.normalization.normalize(ve, me))

    end

end

for ve in [[0], [-1, 0, 0, 1, 1, 1, 2]]

    println(ve)

    for me in ["1223", "1224", "1 2.5 2.5 4", "1234"]

        println(me)

        println(OnePiece.normalization.normalize(ve, me))

    end

end

# ----------------------------------------------------------------------------------------------- #
ve = [NaN, -2, 0, NaN, 2, NaN]

println(ve)

println(OnePiece.normalization.normalize!(ve, "0-1"))

println(ve)

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
