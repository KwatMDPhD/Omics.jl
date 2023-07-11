using DataFrames: DataFrame

using Test: @test

using BioLab

# ---- #

const CO1_ = vcat("Row Name", string.("Column ", 1:5))

VE_ = [
    ["Row 1", 1, 2, 3, 4, 5.0],
    ["Row 2", 'A', 'B', 'C', 44, 55.0],
    ["Row 3", ":)", ";)", ":D", 444, 555.0],
]

@test BioLab.DataFrame.make(CO1_, VE_) == DataFrame(
    "Row Name" => string.("Row ", 1:3),
    "Column 1" => [1, 'A', ":)"],
    "Column 2" => [2, 'B', ";)"],
    "Column 3" => [3, 'C', ":D"],
    "Column 4" => [4, 44, 444],
    "Column 5" => [5.0, 55.0, 555.0],
)

# 1.629 μs (28 allocations: 2.47 KiB)
@btime BioLab.DataFrame.make($CO1_, $VE_);

# ---- #

const N_RO = 3

const N_CO = 4

const NAR = "Row Name"

const RO_ = string.("Row ", 1:N_RO)

const CO2_ = string.("Column ", 1:N_CO)

const MA = Matrix(reshape(1:(N_RO * N_CO), (N_RO, N_CO)))

# ---- #

const DA1 = BioLab.DataFrame.make(NAR, RO_, CO2_, MA)

# ---- #

@test !(Any in eltype.(eachcol(DA1)))

@test size(DA1) == (N_RO, N_CO + 1)

@test DA1 == DataFrame(
    "Row Name" => string.("Row ", 1:N_RO),
    ("Column $id" => view(MA, :, id) for id in 1:N_CO)...,
)

# 1.104 μs (22 allocations: 1.89 KiB)
@btime BioLab.DataFrame.make($NAR, $RO_, $CO2_, $MA);

# ---- #

@test BioLab.DataFrame.separate(DA1) == (NAR, RO_, CO2_, MA)

BioLab.DataFrame.separate(DA1)[2][1] = ":("

@test DA1[1, 1] == "Row 1"

# 2.343 μs (28 allocations: 2.08 KiB)
@btime BioLab.DataFrame.separate($DA1);
