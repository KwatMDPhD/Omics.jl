TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using OnePiece

println(":triangular_flag: is a triangular flag.")

OnePiece.emoji.print(":triangular_flag: is a triangular flag.")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end
