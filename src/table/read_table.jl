using DataFrames: DataFrame

function read_table(pa::String)::DataFrame

    return DataFrame(File(pa))

end

export read_table
