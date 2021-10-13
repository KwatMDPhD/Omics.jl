using CSV: write as CSV_write
using DataFrames: DataFrame

function write(pa::String, ta::DataFrame)::String

    println(pa)

    if !occursin(r"\.tsv$", pa)

        error("path does not end with \".tsv\"")

    end

    return CSV_write(pa, ta; delim = '\t')

end

export write
