using CSV: write as CSV_write
using DataFrames: DataFrame

function write(pa::String, ta::DataFrame)::Int64

    println(pa)

    @assert occursin(r"\.tsv$", pa)

    return CSV_write(pa, ta; delim = '\t')

end

export write
