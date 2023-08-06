using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "Gene")

# ---- #

@test BioLab.Path.read(DA) == ["ensembl.tsv.gz", "uniprot.tsv.gz"]

# ---- #

const EN_NA = BioLab.Gene.map_ensembl()

@test length(EN_NA) == 788360

for (ke, va) in (("GPI-214", "GPI"), ("ENST00000303227", "GLOD5"), ("ENST00000592956.1", "SYT5"))

    @test EN_NA[ke] == va

end

# ---- #

const PR_DI = BioLab.Gene.map_uniprot()

@test PR_DI["CD8A"]["Gene Names"] == ["CD8A", "MAL"]
