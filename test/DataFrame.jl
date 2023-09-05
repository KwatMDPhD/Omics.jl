using DataFrames: DataFrame

using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "DataFrame")

# ---- #

@test BioLab.Path.read(DA) ==
      ["12859_2019_2886_MOESM2_ESM.xlsx", "enst_gene.tsv.gz", "titanic.tsv"]

# ---- #

function make_axis(pr, n)

    ["$pr$id" for id in 1:n]

end

# ---- #

const N_RO = 3

const N_CO = 4

const NAR = "Row Name"

const RO_ = make_axis("Row ", N_RO)

const CO_ = make_axis("Column ", N_CO)

const MA = BioLab.Simulation.make_matrix_1n(N_RO, N_CO)

const DAMS = BioLab.DataFrame.make(NAR, RO_, CO_, MA)

# ---- #

@test all(co -> eltype(co) != Any, eachcol(DAMS))

@test size(DAMS) == (N_RO, N_CO + 1)

@test DAMS == DataFrame(
    "Row Name" => make_axis("Row ", N_RO),
    ("Column $id" => view(MA, :, id) for id in 1:N_CO)...,
)

# 1.113 μs (22 allocations: 1.89 KiB)
#@btime BioLab.DataFrame.make($NAR, $RO_, $CO_, $MA);

# ---- #

@test BioLab.DataFrame.separate(DAMS) == (NAR, RO_, CO_, MA)

BioLab.DataFrame.separate(DAMS)[2][1] = ":("

@test DAMS[1, 1] == "Row 1"

# 2.204 μs (28 allocations: 2.08 KiB)
#@btime BioLab.DataFrame.separate($DAMS);

# ---- #

for (na, re) in (("titanic.tsv", (1309, 15)), ("enst_gene.tsv.gz", (256183, 2)))

    @test size(BioLab.DataFrame.read(joinpath(DA, na))) == re

end

# ---- #

@test size(
    BioLab.DataFrame.read(
        joinpath(DA, "12859_2019_2886_MOESM2_ESM.xlsx");
        xl = "HumanSpecific Genes",
    ),
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

@test eltype.(
    eachcol(BioLab.DataFrame.read(BioLab.DataFrame.write(joinpath(BioLab.TE, "write.tsv"), DT)))
) == [Int, Float64, Int, Float64]
