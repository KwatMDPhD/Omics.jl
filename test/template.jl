TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using OnePiece

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end
