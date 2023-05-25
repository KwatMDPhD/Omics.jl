include("_.jl")

# ---- #

io_x_sa_x_an = BioLab.Table.read(
    "/Users/kwat/craft/pro/VaccineResponse.pro/output/SDY1264/information_x_sample0_x_anything.tsv",
)

fe_x_sa_x_nu = BioLab.Table.read(
    "/Users/kwat/craft/pro/VaccineResponse.pro/output/SDY1264/gene_x_sample0_x_numbercollapsed.tsv",
)

@test names(io_x_sa_x_an)[2:end] == names(fe_x_sa_x_nu)[2:end]
