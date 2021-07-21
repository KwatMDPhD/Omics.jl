using CSV: read
using DataFrames: DataFrame
using Mmap: mmap


function read_table(pa::String; s::String = "")::DataFrame

    return DataFrame(read(mmap(pa)))

end

export read_table
