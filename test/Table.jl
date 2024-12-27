using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using DataFrames: DataFrame

# ---- #

@test Omics.Table.make(
    "Name",
    ["R1", "R2"],
    ["C1", "C2", "C3"],
    [
        1 3 5
        2 4 6
    ],
) == DataFrame("Name" => ["R1", "R2"], "C1" => [1, 2], "C2" => [3, 4], "C3" => [5, 6])

# ---- #

const DA = pkgdir(Omics, "data", "Table")

const WR = joinpath(tempdir(), "writ.tsv")

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
