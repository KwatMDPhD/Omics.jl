module GCT

using CSV: read as _read

using DataFrames: DataFrame, Not

function read(gc)

    return CSV_read(gc, DataFrame; header = 3, delim = '\t')[!, Not("Description")]

end

end
