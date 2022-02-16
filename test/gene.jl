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

# ----------------------------------------------------------------------------------------------- #
hg = OnePiece.gene.read_hgnc()

size(hg)

en = OnePiece.gene.read_ensembl()

size(en)

en = OnePiece.gene.read_ensembl(; or = "mouse")

size(en)

st_hg = OnePiece.gene.map_to_hgnc_gene()

st_en = OnePiece.gene.map_to_ensembl_gene()

OnePiece.gene.map_with_mouse()

OnePiece.gene.map_with_mouse(; ho = "human_to_mouse")

hg_ = string.(hg[!, "symbol"])

;

na_, ma_ = OnePiece.gene.rename(hg_)

ge_ = unique(skipmissing(en[!, "Gene name"]))

na_, ma_ = OnePiece.gene.rename(ge_; mo = false, en = false)

hg_gr = OnePiece.dataframe.map_to_column(coalesce.(hg, "?"), ["symbol", "gene_group"])

println(join(unique([hg_gr[na] for na in na_[ma_ .== 1]]), "\n"))

en_ty = OnePiece.dataframe.map_to_column(en, ["Gene name", "Gene type"])

println(join(unique([en_ty[na] for na in na_[ma_ .== 2]]), "\n"))

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
