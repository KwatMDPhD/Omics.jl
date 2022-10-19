module GEO

using DataFrames: DataFrame, rename!

using GZip: open

using OrderedCollections: OrderedDict

using ..OnePiece

include("../_include.jl")

@_include()

end
