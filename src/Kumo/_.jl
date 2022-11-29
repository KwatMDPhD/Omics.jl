module Kumo

import Base: <<, >>

using InteractiveUtils: supertypes

using LinearAlgebra: norm

using StatsBase: mean

using ..BioLab

include("../_include.jl")

@_include()

end
