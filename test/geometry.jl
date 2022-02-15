TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using OnePiece

for (co1, co2) in [[0, 100], [-1, 1]]

    println("-"^99)

    println(co1, " ... ", co2)

    println(OnePiece.informatics.geometry.get_center(co1, co2))

end

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end
