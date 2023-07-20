using DataFrames: DataFrame

using Test: @test

using BioLab

# ---- #

function make_axis(pr, n)

    string.(pr, 1:n)

end

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
