module DataFrame

using DataFrames: DataFrames, insertcols!

using StatsBase: median

using ..BioLab

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
