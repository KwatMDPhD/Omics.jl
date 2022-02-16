# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "gct.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
OnePiece.dataframe.view(OnePiece.gct.read(joinpath(@__DIR__, "gct.data", "a.gct")))

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
