module FeatureXSample

using StatsBase: mean, median

using ..BioLab

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
