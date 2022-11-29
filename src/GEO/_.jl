module GEO

using DataFrames: DataFrame, rename!

using GZip: open

using OrderedCollections: OrderedDict

using ..BioLab

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
