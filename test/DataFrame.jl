using DataFrames

include("environment.jl")

# ---- #

da = DataFrame(
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
)) == da

# ---- #

@test BioLab.DataFrame.make("""
                      Row Name\tColumn 1\tColumn 2\tColumn 3\tColumn 4\tColumn 5
                      Row 1\t1\t2\t3\t4\t5.0
                      Row 2\tA\tB\tC\t44\t55.0
                      Row 3\t:)\t;)\t:D\t444\t555.0""") == string.(da)

# ---- #

n_ro = 3

n_co = 4

ro = "Row Name"

ro_ = ["Row $id" for id in 1:n_ro]

co_ = ["Column $id" for id in 1:n_co]

ma = rand(n_ro, n_co)

# ---- #

# @test
row_x_column_x_anything = BioLab.DataFrame.make(ro, ro_, co_, ma)

# ---- #

@test BioLab.DataFrame.separate(row_x_column_x_anything) == (ro, ro_, co_, ma)

# ---- #

@test BioLab.DataFrame.separate(row_x_column_x_anything) isa
      Tuple{String, Vector{String}, Vector{String}, Matrix}

# ---- #

BioLab.DataFrame.separate(row_x_column_x_anything)[2][1] = ":("

@test row_x_column_x_anything[1, 1] == ro

# ---- #

ro_x_co_x_an = DataFrame(
    "Row Name" => ["Row $id" for id in 1:3],
    "Column 1" => [1, 'A', ":)"],
    "Column 2" => [2, 'B', ";)"],
    "Column 3" => [3, 'C', ":D"],
)

# ---- #

for an___ in (
    (
        ["Row Name", "Column 1", "Column 2"],
        ["Row 1", 1, 2],
        ["Row 2", 10, 20],
        ["Row 3", 100, 200],
    ),
    (
        ["Row Name", "Column 1", "Column 2"],
        ["Row 1", 1, 2],
        ["Row 1", 10, 20],
        ["Row 2", 100, 200],
    ),
    (
        ["Row Name", "Column 1", "Column 2"],
        ["Row 1", 1, 2],
        ["Row 1", 10, 20],
        ["Row 1", 100, 200],
    ),
)

    # TODO: Test.
    BioLab.DataFrame.collapse(BioLab.DataFrame.make(an___))

end

# ---- #

ro_x_co_x_st = DataFrame(
    "M1" => ["M11", "M12", "M13", "M14"],
    "F" => ["F1", "F2", "F3", missing],
    "M2" => ["M21", "M22", "M23", "M24"],
)

for fr_ in (["M1"], ["M1", "M2"])

    # TODO: Test.
    BioLab.DataFrame.map_to(ro_x_co_x_st, BioLab.Dict.set_with_first!, fr_, "F")

end
