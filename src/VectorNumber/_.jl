module VectorNumber

using Distributions: Normal

using Random: seed!

using ..BioLab

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
