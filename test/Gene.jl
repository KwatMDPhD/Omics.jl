using Logging: Debug, Info, disable_logging

using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab.DA, "Gene")

# ---- #

@test readdir(DA) == ["ensembl.tsv.gz", "uniprot.tsv.gz"]

# ---- #

disable_logging(Info)

const EN_NA = BioLab.Gene.map_ensembl()

disable_logging(Debug)

@test length(EN_NA) == 788360#828011

for (ke, va) in (("GPI-214", "GPI"), ("ENST00000303227", "GLOD5"), ("ENST00000592956.1", "SYT5"))

    @test EN_NA[ke] == va

end

# ---- #

const PR_IO_AN = BioLab.Gene.map_uniprot()

@test PR_IO_AN["CD8A"]["Gene Names"] == ["CD8A", "MAL"]
