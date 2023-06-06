using DataFrames

include("environment.jl")

# ---- #

te = joinpath(tempdir(), "BioLab.test.Table")

BioLab.Path.reset(te)

# ---- #

di = joinpath(DA, "Table")

# ---- #

for na in ("titanic.tsv", "enst_gene.tsv.gz")

    # TODO: Test.

    da = BioLab.Table.read(joinpath(di, na))

    println(first(da, 2))

    println(last(da, 2))

end

# ---- #

# TODO: Test.

da = BioLab.Table.read(joinpath(di, "12859_2019_2886_MOESM2_ESM.xlsx"); xl = "HumanSpecific Genes")

println(first(da, 2))

println(last(da, 2))

# ---- #

co1 = 1:4

co2 = 1.0:4

ro_x_co_x_an = DataFrame(
    "Column 1" => co1,
    "Column 2" => co2,
    "Column 3" => map(string, co1),
    "Column 4" => map(string, co2),
)

# ---- #

ts = joinpath(te, "write.csv")

@test @is_error BioLab.Table.write(ts, ro_x_co_x_an)

# ---- #

ts = replace(ts, ".csv" => ".tsv")

BioLab.Table.write(ts, ro_x_co_x_an)

@test ro_x_co_x_an != BioLab.Table.read(ts)
