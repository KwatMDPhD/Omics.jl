# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "gene.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

println("-"^99)

println("read_ensembl")

println("-"^99)

en = OnePiece.gene.read_ensembl()

OnePiece.dataframe.view(en)

println("-"^99)

println("read_hgnc")

println("-"^99)

hg = OnePiece.gene.read_hgnc()

OnePiece.dataframe.view(hg)

println("-"^99)

println("map_to_ensembl_gene")

println("-"^99)

OnePiece.dict.view(OnePiece.gene.map_to_ensembl_gene(), n_pa = 3)

println("-"^99)

println("map_to_hgnc_gene")

println("-"^99)

OnePiece.dict.view(OnePiece.gene.map_to_hgnc_gene(), n_pa = 3)

println("-"^99)

println("map_with_mouse")

println("-"^99)

OnePiece.dict.view(OnePiece.gene.map_with_mouse(), n_pa = 3)

println("-"^99)

println("rename (Ensembl)")

println("-"^99)

na_, ma_ = OnePiece.gene.rename(unique(skipmissing(en[!, "Gene name"])), en = false, mo = false)

println("-"^99)

println("rename (HGNC)")

println("-"^99)

na_, ma_ = OnePiece.gene.rename(unique(skipmissing(hg[!, "symbol"])), hg = false, mo = false)

# ----------------------------------------------------------------------------------------------- #
println("Done.")
