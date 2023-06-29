using DataFrames: DataFrame

include("environment.jl")

# ---- #

DA = joinpath(BioLab.DA, "Table")

@test readdir(DA) == []

# ---- #

for (na, re) in (("titanic.tsv", (1309, 15)), ("enst_gene.tsv.gz", (256183, 2)))

    @test size(BioLab.Table.read(joinpath(DA, na))) == re

end

# ---- #

@test size(
    BioLab.Table.read(joinpath(DA, "12859_2019_2886_MOESM2_ESM.xlsx"); xl = "HumanSpecific Genes"),
) == (873, 8)

# ---- #

co1 = 1:4

co2 = 1.0:4

da = DataFrame(
    "Column 1" => co1,
    "Column 2" => co2,
    "Column 3" => map(string, co1),
    "Column 4" => map(string, co2),
)

# ---- #

ts = joinpath(TE, "write.csv")

@test @is_error BioLab.Table.write(ts, da)

# ---- #

ts = replace(ts, "csv" => "tsv")

@test !@is_error BioLab.Table.write(ts, da)

@test da != BioLab.Table.read(ts)
