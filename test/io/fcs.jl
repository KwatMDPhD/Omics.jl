TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using OnePiece

OnePiece.io.fcs.read

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end
