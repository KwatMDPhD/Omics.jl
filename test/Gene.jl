using Logging: Debug, Info, disable_logging

using Test: @test

using BioLab

# ---- #

DA = joinpath(BioLab.DA, "Gene")

# ---- #

@test readdir(DA) == ["ensembl.tsv.gz", "uniprot.tsv.gz"]

# ---- #

en = BioLab.Table.read(joinpath(DA, "ensembl.tsv.gz"))

# ---- #

un = BioLab.Table.read(joinpath(DA, "uniprot.tsv.gz"))

# ---- #

disable_logging(Info)
en_na = BioLab.Gene.map_ensembl()
disable_logging(Debug)

@test length(en_na) == 828011

for (ke, va) in (("GPI-214", "GPI"), ("ENST00000303227", "GLOD5"), ("ENST00000592956.1", "SYT5"))

    @test en_na[ke] == va

end

# ---- #

pr_io_an = BioLab.Gene.map_uniprot()

@test pr_io_an["CD8A"]["Gene Names"] == ["CD8A", "MAL"]
