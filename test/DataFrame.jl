using DataFrames: DataFrame

using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "DataFrame")

# ---- #

@test BioLab.Path.read(DA) ==
      ["12859_2019_2886_MOESM2_ESM.xlsx", "enst_gene.tsv.gz", "titanic.tsv"]

# ---- #

const NAR = "Row Name"

# ---- #

@test BioLab.DataFrame.make(NAR, "Row 1", String[], Matrix(undef, 0, 0)) ==
      DataFrame(NAR => "Row 1")

# ---- #

const N_RO = 3

# ---- #

const N_CO = 4

# ---- #

function make_axis(pr, n)

    (id -> "$pr$id").(1:n)

end

# ---- #

const RO_ = make_axis("Row ", N_RO)

# ---- #

const CO_ = make_axis("Column ", N_CO)

# ---- #

const MA = BioLab.Simulation.make_matrix_1n(Int, N_RO, N_CO)

# ---- #

const DT = BioLab.DataFrame.make(NAR, RO_, CO_, MA)

# ---- #

@test DT == DataFrame(
    NAR => make_axis("Row ", N_RO),
    ("Column $id" => view(MA, :, id) for id in 1:N_CO)...,
)

# ---- #

# 1.108 μs (22 allocations: 1.89 KiB)
#@btime BioLab.DataFrame.make(NAR, RO_, CO_, MA);

# ---- #

@test BioLab.DataFrame.separate(DT) == (NAR, RO_, CO_, MA)

# ---- #

BioLab.DataFrame.separate(DT)[2][1] = ""

# ---- #

@test DT[1, 1] === "Row 1"

# ---- #

# 1.938 μs (28 allocations: 2.08 KiB)
#@btime BioLab.DataFrame.separate(DT);

# ---- #

for (na, re) in (("titanic.tsv", (1309, 15)), ("enst_gene.tsv.gz", (256183, 2)))

    @test size(BioLab.DataFrame.read(joinpath(DA, na))) === re

end

# ---- #

@test size(
    BioLab.DataFrame.read(joinpath(DA, "12859_2019_2886_MOESM2_ESM.xlsx"), "HumanSpecific Genes"),
) === (873, 8)

# ---- #

const TS = joinpath(BioLab.TE, "write.tsv")

# ---- #

const IT_ = 1:4

# ---- #

const FL_ = 1.0:4

# ---- #

BioLab.DataFrame.write(
    TS,
    DataFrame(
        "Column Int" => IT_,
        "Column Float" => FL_,
        "Column Int String" => string.(IT_),
        "Column Float String" => string.(FL_),
    ),
)

# ---- #

@test eltype.(eachcol(BioLab.DataFrame.read(TS))) == [Int, Float64, Int, Float64]
