include("environment.jl")

# ---- #

mo = BioLab.Gene.read_mouse()

# ---- #

en = BioLab.Gene.read_ensembl()

# ---- #

hg = BioLab.Gene.read_hgnc()

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

# ---- #

na_, ma_ = BioLab.Gene.rename(unique(skipmissing(en[!, "Gene name"])), en_na)
