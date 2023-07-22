using DataFrames: DataFrame

using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "Table")

# ---- #

@test readdir(DA) == ["12859_2019_2886_MOESM2_ESM.xlsx", "enst_gene.tsv.gz", "titanic.tsv"]

# ---- #

for (na, re) in (("titanic.tsv", (1309, 15)), ("enst_gene.tsv.gz", (256183, 2)))

    @test size(BioLab.Table.read(joinpath(DA, na))) == re

end

@test size(
    BioLab.Table.read(joinpath(DA, "12859_2019_2886_MOESM2_ESM.xlsx"); xl = "HumanSpecific Genes"),
) == (873, 8)

# ---- #

const CO1 = 1:4

const CO2 = 1.0:4

const DT = DataFrame(
    "Column 1" => CO1,
    "Column 2" => CO2,
    "Column 3" => string.(CO1),
    "Column 4" => string.(CO2),
)

const TS = joinpath(BioLab.TE, "write.tsv")

BioLab.Table.write(TS, DT)

@test eltype.(eachcol(BioLab.Table.read(TS))) == [Int, Float64, Int, Float64]
