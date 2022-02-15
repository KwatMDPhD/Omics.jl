TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using OnePiece

da = joinpath("gmt.data", "")

;

gm = joinpath(da, "h.all.v7.1.symbols.gmt")

;

OnePiece.io.gmt.read(gm)

OnePiece.io.gmt.read([gm, joinpath(da, "c2.all.v7.1.symbols.gmt")])

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end
