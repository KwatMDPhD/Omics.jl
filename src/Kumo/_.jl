module Kumo

import Base: <<, >>

using InteractiveUtils: supertypes

using LinearAlgebra: norm

using StatsBase: mean

using ..BioLab

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
