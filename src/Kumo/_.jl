module Kumo

import Base: <<, >>

using InteractiveUtils: supertypes

using LinearAlgebra: norm

using StatsBase: mean

using ..BioinformaticsCore

include("../_include.jl")

@_include()

end
