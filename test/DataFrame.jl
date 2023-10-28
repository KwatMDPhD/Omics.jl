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

const RO_ = (id -> "Row $id").(1:N_RO)

# ---- #

const CO_ = (id -> "Column $id").(1:N_CO)

# ---- #

const MA = Nucleus.Simulation.make_matrix_1n(Int, N_RO, N_CO)

# ---- #

const DT = Nucleus.DataFrame.make(NAR, RO_, CO_, MA)

# ---- #

@test DT == DataFrame(NAR => RO_, ("Column $id" => view(MA, :, id) for id in 1:N_CO)...)

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

    @test size(Nucleus.DataFrame.read(joinpath(DA, na))) === re

end

# ---- #

@test size(
    Nucleus.DataFrame.read(joinpath(DA, "12859_2019_2886_MOESM2_ESM.xlsx"), "HumanSpecific Genes"),
) === (873, 8)

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

# ---- #

Nucleus.DataFrame.write(TS, NAR, RO_, CO_, MA)

# ---- #

@test Nucleus.DataFrame.separate(TS) == (NAR, RO_, CO_, MA)
