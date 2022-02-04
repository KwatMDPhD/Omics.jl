using DataFrames: DataFrame, Not, rename
using CSV: File

function read(pa::String; na::String = "Name")::DataFrame

    return rename(
        select(DataFrame(File(pa; header = 3, delim = '\t')), Not("Description")),
        "Name" => na,
    )

end
