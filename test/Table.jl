using DataFrames: DataFrame

include("environment.jl")

# ---- #

DA = joinpath(BioLab.DA, "Table")

# ---- #

for na in ("titanic.tsv", "enst_gene.tsv.gz")

    # TODO: Test.
    BioLab.Table.read(joinpath(DA, na))

end

# ---- #

# TODO: Test.
BioLab.Table.read(joinpath(DA, "12859_2019_2886_MOESM2_ESM.xlsx"); xl = "HumanSpecific Genes")

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

te = joinpath(tempdir(), "BioLab.test.Table")

BioLab.Path.reset(te)

ts = joinpath(te, "write.csv")

@test @is_error BioLab.Table.write(ts, da)

# ---- #

ts = replace(ts, "csv" => "tsv")

BioLab.Table.write(ts, da)

@test da != BioLab.Table.read(ts)
