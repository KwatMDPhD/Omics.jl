using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

@test KE_VA == LeMoIO.read_dictionary(LeMoIO.write_dictionary(WR, KE_VA))

# ---- #

const TI = LeMoIO.read_table(joinpath(DA, "titanic.tsv"))

# ---- #

@test all(map(isequal, eachcol(TI), eachcol(LeMoIO.read_table(LeMoIO.write_table(WR, TI)))))

# ---- #

const EN = LeMoIO.read_table(joinpath(DA, "enst_gene.tsv.gz"))

# ---- #

@test EN == LeMoIO.read_table(LeMoIO.write_table(WR, EN))

# ---- #

const XL = LeMoIO.read_table(
    joinpath(DA, "12859_2019_2886_MOESM2_ESM.xlsx"),
    "HumanSpecific Genes",
)

# ---- #

LeMoIO.read_table(LeMoIO.write_table(WR, XL))
