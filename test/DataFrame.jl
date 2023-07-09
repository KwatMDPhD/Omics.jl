using DataFrames: DataFrame

using Test: @test

using BioLab

# ---- #

@test BioLab.DataFrame.make((
    vcat("Row Name", string.("Column ", 1:5)),
    ["Row 1", 1, 2, 3, 4, 5.0],
    ["Row 2", 'A', 'B', 'C', 44, 55.0],
    ["Row 3", ":)", ";)", ":D", 444, 555.0],
)) == DataFrame(
    "Row Name" => string.("Row ", 1:3),
    "Column 1" => [1, 'A', ":)"],
    "Column 2" => [2, 'B', ";)"],
    "Column 3" => [3, 'C', ":D"],
    "Column 4" => [4, 44, 444],
    "Column 5" => [5.0, 55.0, 555.0],
)

# ---- #

n_ro = 3

n_co = 4

ro = "Row Name"

ro_ = string.("Row ", 1:n_ro)

co_ = string.("Column ", 1:n_co)

ma = reshape(1:(n_ro * n_co), (n_ro, n_co))

# ---- #

da = BioLab.DataFrame.make(ro, ro_, co_, ma)

@test size(da) == (n_ro, n_co + 1)

@test da == DataFrame(
    "Row Name" => string.("Row ", 1:n_ro),
    ("Column $id" => view(ma, :, id) for id in 1:n_co)...,
)

# 1.121 μs (22 allocations: 1.89 KiB)
#@btime BioLab.DataFrame.make($ro, $ro_, $co_, $ma);

# ---- #

@test BioLab.DataFrame.separate(da) == (ro, ro_, co_, ma)

BioLab.DataFrame.separate(da)[2][1] = ":("

@test da[1, 1] == "Row 1"

# 2.106 μs (28 allocations: 2.08 KiB)
#@btime BioLab.DataFrame.separate($da);

# ---- #

da = DataFrame(
    "M1" => [nothing, "M12", "M13", "M14"],
    "F" => ["F1", missing, "F3", "F4"],
    "M2" => ["M21", "M22", "", "M24"],
)

for (fr_, re) in (
    (["M1"], Dict("F1" => "F1", "F3" => "F3", "M13" => "F3", "F4" => "F4", "M14" => "F4")),
    (
        ["M1", "M2"],
        Dict(
            "F1" => "F1",
            "M21" => "F1",
            "F3" => "F3",
            "M13" => "F3",
            "F4" => "F4",
            "M14" => "F4",
            "M24" => "F4",
        ),
    ),
)

    @test BioLab.DataFrame.map(da, BioLab.Dict.set_with_first!, fr_, "F") == re

end

# ---- #

@test BioLab.DataFrame.map(
    DataFrame("From" => ["A B", "C D"], "To" => [1, 2]),
    BioLab.Dict.set_with_first!,
    ["From"],
    "To";
    de = " ",
) == Dict(1 => 1, "A" => 1, "B" => 1, 2 => 2, "C" => 2, "D" => 2)
