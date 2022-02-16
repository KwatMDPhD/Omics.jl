# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "table.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
da = joinpath(@__DIR__, "table.data")

OnePiece.table.read(joinpath(da, "titanic.tsv"))

OnePiece.table.read(joinpath(da, "enst_gene.tsv.gz"))

OnePiece.table.read(joinpath(da, "12859_2019_2886_MOESM2_ESM.xlsx"), xl = "HumanSpecific Genes")

# ----------------------------------------------------------------------------------------------- #
using DataFrames

# ----------------------------------------------------------------------------------------------- #
co1 = 1:4

co2 = 1.0:4

da = DataFrame(
    "Column 1" => co1,
    "Column 2" => co2,
    "Column 3" => string.(co1),
    "Column 4" => string.(co2),
)

ts = joinpath(TE, "write.csv")

try

    OnePiece.table.write(ts, da)

catch er

    println(er)

end

OnePiece.table.write(replace(ts, ".csv" => ".tsv"), da)

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
