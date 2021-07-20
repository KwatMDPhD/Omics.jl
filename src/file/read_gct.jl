using CSV: File
using DataFrames: DataFrame, Not, rename!, select!

function read_gct(p::String; n::String = "Axis 0 Name")::DataFrame

    df = DataFrame(File(p; header = 3, delim = '\t'))

    select!(df, Not(Symbol("Description")))

    rename!(df, Symbol("Name") => Symbol(n))

    return df

end

export read_gct
