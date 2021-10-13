using CSV: write as CSV_write
using DataFrames: DataFrame

function write(pa::String, ta::DataFrame)::Int64

    println(pa)

    @assert endswith(pa, ".tsv")

    return CSV_write(pa, ta; delim = '\t')

end

export write
