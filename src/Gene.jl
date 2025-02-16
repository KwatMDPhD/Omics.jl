module Gene

using ..Omics

const _HG = pkgdir(Omics, "data", "Gene", "hgnc.tsv.gz")

const _EN = pkgdir(Omics, "data", "Gene", "ensembl.tsv.gz")

function map_hgnc(ke_)

    Omics.Ma.make(Omics.Table.rea(_HG), ke_, "symbol")

end

function map_ensembl(
    ke_ = [
        "Transcript stable ID version",
        "Transcript stable ID",
        "Transcript name",
        "Gene stable ID version",
        "Gene stable ID",
    ],
)

    Omics.Ma.make(Omics.Table.rea(_EN), ke_, "Gene name")

end

end
