TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using OnePiece

gc = joinpath("gct.data", "a.gct")

;

OnePiece.io.gct.read(gc)

OnePiece.io.gct.read(gc; na = "Heso")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end
