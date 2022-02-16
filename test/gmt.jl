# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "gmt.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
da = joinpath(@__DIR__, "gmt.data")

gm = joinpath(da, "h.all.v7.1.symbols.gmt")

n_pa = 2

OnePiece.dict.view(OnePiece.gmt.read(gm), n_pa = n_pa)

OnePiece.dict.view(OnePiece.gmt.read([gm, joinpath(da, "c2.all.v7.1.symbols.gmt")]), n_pa = n_pa)

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
