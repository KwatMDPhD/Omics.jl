using DataFrames: DataFrame

using Test: @test

using BioLab

# ---- #

function make_axis(pr, n)

    string.(pr, 1:n)

end

## ---- #
#
#const CO1_ = vcat("Row Name", make_axis("Column ",5))
#
#const VE_ = [
#    ["Row 1", 1, 2, 3, 4, 5.0],
#    ["Row 2", 'A', 'B', 'C', 44, 55.0],
#    ["Row 3", ":)", ";)", ":D", 444, 555.0],
#]
#
#@test BioLab.DataFrame.make(CO1_, VE_) == DataFrame(
#    "Row Name" => make_axis("Row ", 3),
#    "Column 1" => [1, 'A', ":)"],
#    "Column 2" => [2, 'B', ";)"],
#    "Column 3" => [3, 'C', ":D"],
#    "Column 4" => [4, 44, 444],
#    "Column 5" => [5.0, 55.0, 555.0],
#)
#
## 1.629 μs (28 allocations: 2.44 KiB)
#@btime BioLab.DataFrame.make($CO1_, $VE_);
#
# ---- #

const N_RO = 3

const N_CO = 4

const NAR = "Row Name"

const RO_ = make_axis("Row ", N_RO)

const CO_ = make_axis("Column ", N_CO)

const MA = Matrix(reshape(1:(N_RO * N_CO), (N_RO, N_CO)))

# ---- #

const DA1 = BioLab.DataFrame.make(NAR, RO_, CO_, MA)

# ---- #

@test all(co -> eltype(co) != Any, eachcol(DA1))

@test size(DA1) == (N_RO, N_CO + 1)

@test DA1 == DataFrame(
    "Row Name" => make_axis("Row ", N_RO),
    ("Column $id" => view(MA, :, id) for id in 1:N_CO)...,
)

# 1.104 μs (22 allocations: 1.89 KiB)
@btime BioLab.DataFrame.make($NAR, $RO_, $CO_, $MA);

# ---- #

@test BioLab.DataFrame.separate(DA1) == (NAR, RO_, CO_, MA)

BioLab.DataFrame.separate(DA1)[2][1] = ":("

@test DA1[1, 1] == "Row 1"

# 2.269 μs (28 allocations: 2.08 KiB)
@btime BioLab.DataFrame.separate($DA1);
