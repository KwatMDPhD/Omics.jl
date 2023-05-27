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
display(BioLab.DataFrame.make(an___))

# @code_warntype BioLab.DataFrame.make(an___)

# 3.266 μs (43 allocations: 3.20 KiB)
# @btime BioLab.DataFrame.make($an___)

n_ro = 3

n_co = 4

ro = "Row Name"

ro_ = ["Row $id" for id in 1:n_ro]

co_ = ["Column $id" for id in 1:n_co]

_x_co_x_an = rand(n_ro, n_co)

ro_x_co_x_an = BioLab.DataFrame.make(ro, ro_, co_, _x_co_x_an)

# TODO: `@test`.
display(ro_x_co_x_an)

# @code_warntype BioLab.DataFrame.make(ro, ro_, co_, _x_co_x_an)

# 1.171 μs (26 allocations: 2.27 KiB)
# @btime BioLab.DataFrame.make($ro, $ro_, $co_, $_x_co_x_an)

# ---- #

@test BioLab.DataFrame.separate(ro_x_co_x_an) == (ro, ro_, co_, _x_co_x_an)

st = ":("

BioLab.DataFrame.separate(ro_x_co_x_an)[2][1] = st

@test ro_x_co_x_an[1, 1] != st

# @code_warntype BioLab.DataFrame.separate(ro_x_co_x_an)

# 2.245 μs (28 allocations: 2.09 KiB)
# @btime BioLab.DataFrame.separate($ro_x_co_x_an)

# ---- #

na_ = ("Name 1", "Name 2")

an___ = ([1, 1.0, 2], [3, 3.0, 4, 4.0, 5])

BioLab.DataFrame._print_unique(na_, an___)

# @code_warntype BioLab.DataFrame._print_unique(na_, an___)

# ---- #

ro_x_co_x_an = DataFrame(
    "Row Name" => ["Row $id" for id in 1:3],
    "Column 1" => [1, 'A', ":)"],
    "Column 2" => [2, 'B', ";)"],
    "Column 3" => [3, 'C', ":D"],
)

# ---- #

BioLab.DataFrame.print_column(ro_x_co_x_an)

# @code_warntype BioLab.DataFrame.print_column(ro_x_co_x_an)

# ---- #

BioLab.DataFrame.print_row(ro_x_co_x_an)

# @code_warntype BioLab.DataFrame.print_row(ro_x_co_x_an)

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

    ro_x_co_x_nu = BioLab.DataFrame.make(an___)

    BioLab.print_header(ro_x_co_x_nu)

    # TODO: `@test`.
    display(BioLab.DataFrame.collapse(ro_x_co_x_nu))

    pr = false

    # @code_warntype BioLab.DataFrame.collapse(ro_x_co_x_nu; pr)

    # 2.106 μs (39 allocations: 2.94 KiB)
    # 3.172 μs (67 allocations: 5.30 KiB) 
    # 3.130 μs (65 allocations: 5.11 KiB)
    # @btime BioLab.DataFrame.collapse($ro_x_co_x_nu; pr = $pr)

end

# ---- #

ro_x_co_x_st = DataFrame(
    "M1" => ["M11", "M12", "M13", "M14"],
    "F" => ["F1", "F2", "F3", missing],
    "M2" => ["M21", "M22", "M23", "M24"],
)

to = "F"

for fr_ in (["M1"], ["M1", "M2"])

    BioLab.print_header("$fr_ ➡️ $to")

    # TODO: `@test`.
    BioLab.Dict.print(BioLab.DataFrame.map_to(ro_x_co_x_st, BioLab.Dict.set_with_first!, fr_, to))

    # @code_warntype BioLab.DataFrame.map_to(ro_x_co_x_st, BioLab.Dict.set_with_first!, fr_, to)

    # 3.927 μs (79 allocations: 4.45 KiB)
    # 5.458 μs (88 allocations: 4.79 KiB)
    # @btime BioLab.DataFrame.map_to($ro_x_co_x_st, $BioLab.Dict.set_with_first!, $fr_, $to)

end
