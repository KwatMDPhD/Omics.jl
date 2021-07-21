using CSV: File
using DataFrames: DataFrame, Not, rename!, select!

function read_gct(pa::String; na::String = "Axis-0 name")::DataFrame

    da = DataFrame(File(pa; header = 3, delim = '\t'))

    select!(da, Not(Symbol("Description")))

    rename!(da, Symbol("Name") => Symbol(na))

    return da

end

export read_gct
