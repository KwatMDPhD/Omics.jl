include("_.jl")

using DataFrames

te = BioLab.Path.make_temporary("BioLab.test.Table")

di = joinpath(@__DIR__, "Table.data")

for na in ("titanic.tsv", "enst_gene.tsv.gz")

    BioLab.print_header(na)

    pa = joinpath(di, na)

    # TODO: `@test`.
    display(BioLab.Table.read(pa))

    # @code_warntype BioLab.Table.read(pa)

end

pa = joinpath(di, "12859_2019_2886_MOESM2_ESM.xlsx")

xl = "HumanSpecific Genes"

BioLab.Table.read(pa; xl)

# @code_warntype BioLab.Table.read(pa; xl)

co1 = 1:4

co2 = 1.0:4

ro_x_co_x_an = DataFrame(
    "Column 1" => co1,
    "Column 2" => co2,
    "Column 3" => [string(an) for an in co1],
    "Column 4" => [string(an) for an in co2],
)

ts = joinpath(te, "write.csv")

@test @is_error BioLab.Table.write(ts, ro_x_co_x_an)

ts = replace(ts, ".csv" => ".tsv")

BioLab.Table.write(ts, ro_x_co_x_an)

ro_x_co_x_an2 = BioLab.Table.read(ts)

@test ro_x_co_x_an != ro_x_co_x_an2
