# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "dataframe.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
using DataFrames

# ----------------------------------------------------------------------------------------------- #
println(OnePiece.dataframe.simulate(3, 3))

# ----------------------------------------------------------------------------------------------- #
OnePiece.dataframe.view(DataFrame())

for (n_ro, n_co) in ((0, 1), (2, 2), (4, 2), (2, 4), (4, 4), (6, 6), (10, 10))

    println("Testing view $n_ro x $n_co")

    OnePiece.dataframe.view(OnePiece.dataframe.simulate(n_ro, n_co))

end

# ----------------------------------------------------------------------------------------------- #
da = DataFrame(
    "Column 1" => ["hi", "hello", "howdy"],
    "Column 2" => ["X", "Y", "Z"],
    "Column 3" => ["luffy", "black jack", "oden"],
)

OnePiece.dict.view(OnePiece.dataframe.map_to_column(da, ["Column 1", "Column 3", "Column 2"]))

OnePiece.dict.view(OnePiece.dataframe.map_to_column(da, ["Column 3", "Column 2"]))

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
