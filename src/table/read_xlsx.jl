using DataFrames: DataFrame
using XLSX: readtable

function read_xlsx(pa::String, sh::String = "")::DataFrame

    return DataFrame(readtable(pa, sh)...)

end

export read_xlsx
