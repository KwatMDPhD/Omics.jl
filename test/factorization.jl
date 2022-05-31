# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "factorization.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
ma = rand(50, 10)

ro_ = string.("Row ", 1:size(ma, 1))

co_ = string.("Column ", 1:size(ma, 2))

k_ = [3, 4, 5]

ti = "Test"

OnePiece.factorization.factorize(ma, ro_, co_, k_, ti, TE)

# ----------------------------------------------------------------------------------------------- #
println("Done.")
