module Kumo

import Base: <<, >>

using InteractiveUtils: supertypes

using LinearAlgebra: norm

using StatsBase: mean

using ..OnePiece

VE_ = []

ED_ = []

include("../_include.jl")

@_include()

end
