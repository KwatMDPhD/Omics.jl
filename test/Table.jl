using DataFrames: DataFrame

using Test: @test

using Omics

# ---- #

@test Omics.Table.make(
    "C1",
    ["R1", "R2"],
    ["C2", "C3", "C4"],
    [
        1 3 5
        2 4 6
    ],
) == DataFrame("C1" => ["R1", "R2"], "C2" => [1, 2], "C3" => [3, 4], "C4" => [5, 6])

# ---- #

const DI = pkgdir(Omics, "data", "Table")

const TS = joinpath(tempdir(), "_.tsv")

# ---- #

const A1 = Omics.Table.rea(joinpath(DI, "titanic.tsv"))

@test all(map(isequal, eachcol(A1), eachcol(Omics.Table.rea(Omics.Table.writ(TS, A1)))))

# ---- #

const A2 = Omics.Table.rea(joinpath(DI, "enst_gene.tsv.gz"))

@test A2 == Omics.Table.rea(Omics.Table.writ(TS, A2))

# ---- #

const A3 =
    Omics.Table.rea(joinpath(DI, "12859_2019_2886_MOESM2_ESM.xlsx"), "HumanSpecific Genes")

Omics.Table.rea(Omics.Table.writ(TS, A3))
