using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

const DA = pkgdir(Omics, "data", "Table")

const WR = joinpath(tempdir(), "write.tsv")

# ---- #

const TI = Omics.Table.rea(joinpath(DA, "titanic.tsv"))

@test all(map(isequal, eachcol(TI), eachcol(Omics.Table.rea(Omics.Table.writ(WR, TI)))))

# ---- #

const EN = Omics.Table.rea(joinpath(DA, "enst_gene.tsv.gz"))

@test EN == Omics.Table.rea(Omics.Table.writ(WR, EN))

# ---- #

const XL =
    Omics.Table.rea(joinpath(DA, "12859_2019_2886_MOESM2_ESM.xlsx"), "HumanSpecific Genes")

Omics.Table.rea(Omics.Table.writ(WR, XL))
