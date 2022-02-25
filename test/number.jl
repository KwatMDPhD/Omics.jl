# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "number.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

println("-"^99)

println("fractionate")

println("-"^99)

for it in 1:28

    println(OnePiece.number.fractionate(it))

end

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
