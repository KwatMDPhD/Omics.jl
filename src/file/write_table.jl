using CSV: write
using DataFrames: DataFrame
function write_table(pa::String, ta::DataFrame)::String

    write(pa, ta; delim = '\t')

end

export write_table
