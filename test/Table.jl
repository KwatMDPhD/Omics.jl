using DataFrames: DataFrame

using Test: @test

using Omics

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

const DI = pkgdir(Omics, "data", "Table")

const FI = joinpath(tempdir(), "_.tsv")

# ---- #

const A1 = Omics.Table.rea(joinpath(DI, "titanic.tsv"))

@test all(map(isequal, eachcol(A1), eachcol(Omics.Table.rea(Omics.Table.writ(FI, A1)))))

# ---- #

const A2 = Omics.Table.rea(joinpath(DI, "enst_gene.tsv.gz"))

@test A2 == Omics.Table.rea(Omics.Table.writ(FI, A2))

# ---- #

const A3 =
    Omics.Table.rea(joinpath(DI, "12859_2019_2886_MOESM2_ESM.xlsx"), "HumanSpecific Genes")

Omics.Table.rea(Omics.Table.writ(FI, A3))
