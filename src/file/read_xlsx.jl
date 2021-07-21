using DataFrames: DataFrame
using XLSX: readtable

function read_xlsx(pa::String; s::String = "")::DataFrame

    return DataFrame(readtable(pa, s)...)

end

export read_xlsx
