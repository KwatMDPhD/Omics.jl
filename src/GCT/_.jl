module GCT

using CSV: read as CSV_read

using DataFrames: DataFrame, Not

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
