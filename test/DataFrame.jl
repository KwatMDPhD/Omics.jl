using DataFrames: DataFrame

using Test: @test

using Nucleus

# ---- #

const DA = joinpath(Nucleus._DA, "DataFrame")

# ---- #

@test Nucleus.Path.read(DA) ==
      ["12859_2019_2886_MOESM2_ESM.xlsx", "enst_gene.tsv.gz", "titanic.tsv"]

# ---- #

const NAR = "Row Name"

# ---- #

@test Nucleus.DataFrame.make(NAR, "Row 1", String[], Matrix(undef, 0, 0)) ==
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

const MA = Nucleus.Simulation.make_matrix_1n(Int, N_RO, N_CO)

# ---- #

const DT = Nucleus.DataFrame.make(NAR, RO_, CO_, MA)

# ---- #

@test DT == DataFrame(
    NAR => make_axis("Row ", N_RO),
    ("Column $id" => view(MA, :, id) for id in 1:N_CO)...,
)

# ---- #

# 1.133 μs (22 allocations: 1.89 KiB)
#@btime Nucleus.DataFrame.make(NAR, RO_, CO_, MA);

# ---- #

@test Nucleus.DataFrame.separate(DT) == (NAR, RO_, CO_, MA)

# ---- #

Nucleus.DataFrame.separate(DT)[2][1] = ""

# ---- #

@test DT[1, 1] === "Row 1"

# ---- #

# 2.231 μs (28 allocations: 2.08 KiB)
#@btime Nucleus.DataFrame.separate(DT);

# ---- #

for (na, re) in (("titanic.tsv", (1309, 15)), ("enst_gene.tsv.gz", (256183, 2)))

    fi = joinpath(DA, na)

    da = Nucleus.DataFrame.read(fi)

    @test size(da) === re

    @test isequal(Nucleus.DataFrame.separate(da), Nucleus.DataFrame.separate(fi))

end

# ---- #

const XL = joinpath(DA, "12859_2019_2886_MOESM2_ESM.xlsx")

# ---- #

const DAX = Nucleus.DataFrame.read(XL, "HumanSpecific Genes")

# ---- #

@test size(DAX) === (873, 8)

# ---- #

@test Nucleus.DataFrame.separate(DAX) == Nucleus.DataFrame.separate(XL, "HumanSpecific Genes")

# ---- #

const TS = joinpath(Nucleus.TE, "write.tsv")

# ---- #

Nucleus.DataFrame.write(
    TS,
    DataFrame(
        "Column Int" => 1:4,
        "Column Float" => 1.0:4,
        "Column Int String" => string.(1:4),
        "Column Float String" => string.(1.0:4),
    ),
)

# ---- #

@test eltype.(eachcol(Nucleus.DataFrame.read(TS))) == [Int, Float64, Int, Float64]
