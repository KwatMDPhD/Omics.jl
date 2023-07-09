using Test: @test

# ---- #

DA = joinpath(BioLab.DA, "Gene")

@test readdir(DA) == ["ensembl.tsv.gz", "uniprot.tsv.gz"]

# ---- #

en = BioLab.Gene.read_ensembl()

# ---- #

un = BioLab.Gene.read_uniprot()

# ---- #

Logging.disable_logging(Info)

en_na = BioLab.Gene.map_ensembl(en)

@test en_na == BioLab.Gene.map_ensembl()

Logging.disable_logging(Debug)

# ---- #

pr_io_an = BioLab.Gene.map_uniprot(un)

@test pr_io_an == BioLab.Gene.map_uniprot()

@test pr_io_an["CD8A"]["Gene Names"] == ["CD8A", "MAL"]
