TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using OnePiece

using DataFrames

da = DataFrame(
    "Column 1" => ["hi", "hello", "howdy"],
    "Column 2" => ["X", "Y", "Z"],
    "Column 3" => ["luffy", "black jack", "oden"],
)

using JSON

JSON.print(OnePiece.extension.dataframe.map_to_column(da, ["Column 1", "Column 3", "Column 2"]), 2)

JSON.print(OnePiece.extension.dataframe.map_to_column(da, ["Column 3", "Column 2"]), 3)

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end
