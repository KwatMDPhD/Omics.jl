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

@test BioLab.DataFrame.make(NAR, "Row 1", Vector{String}(), Matrix(undef, 0, 0)) ==
      DataFrame(NAR => "Row 1")

# ---- #

const N_RO = 3

# ---- #

const N_CO = 4

# ---- #

function make_axis(pr::String, n::Int)::Vector{String}

    ["$pr$id" for id in 1:n]

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

@test DT ==
      DataFrame(NAR => make_axis("Row ", N_RO), ("Column $id" => MA[:, id] for id in 1:N_CO)...)

# ---- #

# 1.108 μs (22 allocations: 1.89 KiB)
#@btime BioLab.DataFrame.make($NAR, $RO_, $CO_, $MA);

# ---- #

for (ro_an__, re) in (
    (
        [
            Dict("Row 1" => 1, "Row 2" => 2),
            Dict("Row 2" => 2, "Row 3" => 3),
            Dict("Row 1" => 1, "Row 2" => 2, "Row 3" => 3),
        ],
        DataFrame(
            NAR => ["Row 1", "Row 2", "Row 3"],
            "Column 1" => [1, 2, missing],
            "Column 2" => [missing, 2, 3],
            "Column 3" => [1, 2, 3],
        ),
    ),
    (
        [
            Dict("Row 1" => 'a', "Row 2" => 'b'),
            Dict("Row 2" => 'b', "Row 3" => 'c'),
            Dict("Row 1" => 'a', "Row 2" => 'b', "Row 3" => 'c'),
        ],
        DataFrame(
            NAR => ["Row 1", "Row 2", "Row 3"],
            "Column 1" => ['a', 'b', missing],
            "Column 2" => [missing, 'b', 'c'],
            "Column 3" => ['a', 'b', 'c'],
        ),
    ),
)

    co_ = make_axis("Column ", length(ro_an__))

    @test isequal(BioLab.DataFrame.make(NAR, co_, ro_an__), re)

    # 1.908 μs (46 allocations: 3.36 KiB)
    # 1.967 μs (46 allocations: 3.19 KiB)
    #@btime BioLab.DataFrame.make($NAR, $co_, $ro_an__)

end

# ---- #

@test BioLab.DataFrame.separate(DT) == (NAR, RO_, CO_, MA)

# ---- #

BioLab.DataFrame.separate(DT)[2][1] = ":("

# ---- #

@test DT[1, 1] === "Row 1"

# ---- #

# 1.938 μs (28 allocations: 2.08 KiB)
#@btime BioLab.DataFrame.separate($DT);

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

const COI_ = 1:4

# ---- #

const COF_ = 1.0:4

# ---- #

BioLab.DataFrame.write(
    TS,
    DataFrame(
        "Column Int" => COI_,
        "Column Float" => COF_,
        "Column Int String" => string.(COI_),
        "Column Float String" => string.(COF_),
    ),
)

# ---- #

@test eltype.(eachcol(BioLab.DataFrame.read(TS))) == [Int, Float64, Int, Float64]
