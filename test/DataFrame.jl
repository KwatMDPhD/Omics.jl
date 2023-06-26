using DataFrames: DataFrame

include("environment.jl")

# ---- #

re = DataFrame(
    "Row Name" => ["Row $id" for id in 1:3],
    "Column 1" => [1, 'A', ":)"],
    "Column 2" => [2, 'B', ";)"],
    "Column 3" => [3, 'C', ":D"],
    "Column 4" => [4, 44, 444],
    "Column 5" => [5.0, 55.0, 555.0],
)

# ---- #

@test BioLab.DataFrame.make((
    vcat("Row Name", ["Column $id" for id in 1:5]),
    ["Row 1", 1, 2, 3, 4, 5.0],
    ["Row 2", 'A', 'B', 'C', 44, 55.0],
    ["Row 3", ":)", ";)", ":D", 444, 555.0],
)) == re

# ---- #

@test BioLab.DataFrame.make("""
                      Row Name\tColumn 1\tColumn 2\tColumn 3\tColumn 4\tColumn 5
                      Row 1\t1\t2\t3\t4\t5.0
                      Row 2\tA\tB\tC\t44\t55.0
                      Row 3\t:)\t;)\t:D\t444\t555.0""") == string.(re)

# ---- #

n_ro = 3

n_co = 4

ro = "Row Name"

ro_ = ["Row $id" for id in 1:n_ro]

co_ = ["Column $id" for id in 1:n_co]

ro_x_co_x_fl = rand(n_ro, n_co)

# ---- #

ron = "Row Name"

con_ = ["Column 1", "Column 2", "Column 3"]

for (ro_an__, re) in (
    (
        (
            Dict("Row 1" => 1, "Row 2" => 2),
            Dict("Row 2" => 2, "Row 3" => 3),
            Dict("Row 1" => 1, "Row 2" => 2, "Row 3" => 3),
        ),
        DataFrame(
            ron => ["Row 1", "Row 2", "Row 3"],
            "Column 1" => [1, 2, missing],
            "Column 2" => [missing, 2, 3],
            "Column 3" => [1, 2, 3],
        ),
    ),
    (
        (
            Dict("Row 1" => 'a', "Row 2" => 'b'),
            Dict("Row 2" => 'b', "Row 3" => 'c'),
            Dict("Row 1" => 'a', "Row 2" => 'b', "Row 3" => 'c'),
        ),
        DataFrame(
            "Row Name" => ["Row 1", "Row 2", "Row 3"],
            "Column 1" => ['a', 'b', missing],
            "Column 2" => [missing, 'b', 'c'],
            "Column 3" => ['a', 'b', 'c'],
        ),
    ),
)

    @test isequal(BioLab.DataFrame.make(ron, con_, ro_an__), re)

    # 3.594 μs (58 allocations: 4.11 KiB)
    # 3.651 μs (58 allocations: 4.02 KiB)
    # @btime BioLab.DataFrame.make($ron, $con_, $ro_an__);

end

# ---- #

row_x_column_x_anything = BioLab.DataFrame.make(ro, ro_, co_, ro_x_co_x_fl)

@test size(row_x_column_x_anything) == (n_ro, n_co + 1)

@test row_x_column_x_anything == DataFrame(
    "Row Name" => ["Row $id" for id in 1:n_ro],
    ("Column $id" => ro_x_co_x_fl[:, id] for id in 1:n_co)...,
)

# ---- #

@test BioLab.DataFrame.separate(row_x_column_x_anything) == (ro, ro_, co_, ro_x_co_x_fl)

BioLab.DataFrame.separate(row_x_column_x_anything)[2][1] = ":("

@test row_x_column_x_anything[1, 1] == "Row 1"

# ---- #

ro_x_co_x_an = DataFrame(
    "Row Name" => ["Row $id" for id in 1:3],
    "Column 1" => [1, 'A', ":)"],
    "Column 2" => [2, 'B', ";)"],
    "Column 3" => [3, 'C', ":D"],
)

# ---- #

for (an___, re) in (
    (
        (
            ["Row Name", "Column 1", "Column 2"],
            ["Row 1", 1, 2],
            ["Row 2", 10, 20],
            ["Row 3", 100, 200],
        ),
        DataFrame(
            "Row Name" => ["Row 1", "Row 2", "Row 3"],
            "Column 1" => [1.0, 10, 100],
            "Column 2" => [2.0, 20, 200],
        ),
    ),
    (
        (
            ["Row Name", "Column 1", "Column 2"],
            ["Row 1", 1, 2],
            ["Row 1", 10, 20],
            ["Row 2", 100, 200],
        ),
        DataFrame(
            "Row Name" => ["Row 1", "Row 2"],
            "Column 1" => [5.5, 100],
            "Column 2" => [11.0, 200],
        ),
    ),
    (
        (
            ["Row Name", "Column 1", "Column 2"],
            ["Row 1", 1, 2],
            ["Row 1", 10, 20],
            ["Row 1", 100, 200],
        ),
        DataFrame("Row Name" => ["Row 1"], "Column 1" => [37.0], "Column 2" => [74.0]),
    ),
)

    @test BioLab.DataFrame.collapse(BioLab.DataFrame.make(an___)) == re

end

# ---- #

row_x_column_x_string = DataFrame(
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

    @test BioLab.DataFrame.map(row_x_column_x_string, BioLab.Dict.set_with_first!, fr_, "F") == re

end

# ---- #

@test BioLab.DataFrame.map(
    DataFrame("From" => ["A B", "C D"], "To" => [1, 2]),
    BioLab.Dict.set_with_first!,
    ["From"],
    "To";
    de = " ",
) == Dict(1 => 1, "A" => 1, "B" => 1, 2 => 2, "C" => 2, "D" => 2)
