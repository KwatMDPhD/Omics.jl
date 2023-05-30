using DataFrames

include("environment.jl")

# ---- #

an___ = (
    vcat("Row Name", ["Column $id" for id in 1:5]),
    ["Row 1", 1, 2, 3, 4, 5.0],
    ["Row 2", 'A', 'B', 'C', 44, 55.0],
    ["Row 3", ":)", ";)", ":D", 444, 555.0],
)

# TODO: `@test`.
println(BioLab.DataFrame.make(an___))

# ---- #

n_ro = 3

n_co = 4

ro = "Row Name"

ro_ = ["Row $id" for id in 1:n_ro]

co_ = ["Column $id" for id in 1:n_co]

ma = rand(n_ro, n_co)

row_x_column_x_anything = BioLab.DataFrame.make(ro, ro_, co_, ma)

# TODO: `@test`.
println(row_x_column_x_anything)

# ---- #

@test BioLab.DataFrame.separate(row_x_column_x_anything) == (ro, ro_, co_, ma)

# ---- #

st = ":("

BioLab.DataFrame.separate(row_x_column_x_anything)[2][1] = st

@test row_x_column_x_anything[1, 1] != st

# ---- #

@test BioLab.DataFrame.separate(row_x_column_x_anything) isa
      Tuple{String, Vector{String}, Vector{String}, Matrix}

# 2.245 μs (28 allocations: 2.09 KiB)
# @btime BioLab.DataFrame.separate($row_x_column_x_anything)

# ---- #

ro_x_co_x_an = DataFrame(
    "Row Name" => ["Row $id" for id in 1:3],
    "Column 1" => [1, 'A', ":)"],
    "Column 2" => [2, 'B', ";)"],
    "Column 3" => [3, 'C', ":D"],
)

# ---- #

BioLab.DataFrame.print_column(ro_x_co_x_an)

# ---- #

BioLab.DataFrame.print_row(ro_x_co_x_an)

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

    local row_x_column_x_anything = BioLab.DataFrame.make(an___)

    # TODO: `@test`.
    println(BioLab.DataFrame.collapse(row_x_column_x_anything))

end

# ---- #

ro_x_co_x_st = DataFrame(
    "M1" => ["M11", "M12", "M13", "M14"],
    "F" => ["F1", "F2", "F3", missing],
    "M2" => ["M21", "M22", "M23", "M24"],
)

for fr_ in (["M1"], ["M1", "M2"])

    # TODO: `@test`.
    BioLab.Dict.print(BioLab.DataFrame.map_to(ro_x_co_x_st, BioLab.Dict.set_with_first!, fr_, "F"))

end
