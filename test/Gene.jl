using Logging

include("environment.jl")

# ---- #

Logging.disable_logging(Warn)

# ---- #

mo = BioLab.Gene.read_mouse()

# ---- #

en = BioLab.Gene.read_ensembl()

# ---- #

hg = BioLab.Gene.read_hgnc()

# ---- #

un = BioLab.Gene.read_uniprot()

# ---- #

mo_na = BioLab.Gene.map_mouse(mo)

@test mo_na == BioLab.Gene.map_mouse()

# ---- #

en_na = BioLab.Gene.map_ensembl(en)

@test en_na == BioLab.Gene.map_ensembl()

# ---- #

hg_na = BioLab.Gene.map_hgnc(hg)

@test hg_na == BioLab.Gene.map_hgnc()

# ---- #

pr_io_an = BioLab.Gene.map_uniprot(un)

@test pr_io_an == BioLab.Gene.map_uniprot()

# ---- #

na_, ma_ = BioLab.Gene.rename(unique(skipmissing(en[!, "Gene name"])), mo_na, hg_na)

# ---- #

@test count(==(1), ma_) == 39077 && count(==(2), ma_) == 509 && count(==(3), ma_) == 65

# ---- #

na_, ma_ = BioLab.Gene.rename(unique(skipmissing(hg[!, "symbol"])), mo_na, en_na)

@test count(==(1), ma_) == 39133 && count(==(2), ma_) == 310 && count(==(3), ma_) == 3683
