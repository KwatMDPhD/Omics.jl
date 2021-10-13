using CSV: File
using DataFrames: DataFrame

function read(pa::String)::DataFrame

    return DataFrame(File(pa))

end

export read
