module Normalization

using StatsBase: competerank, denserank, mean, ordinalrank, std, tiedrank

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
