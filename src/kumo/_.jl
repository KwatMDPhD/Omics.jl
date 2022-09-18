module kumo

import Base: <<, >>

using ColorSchemes

using Colors

using DataFrames

using InteractiveUtils

using LinearAlgebra

using StatsBase

using ..OnePiece

VERTEX_ = []

EDGE_ = []

include("../_include_neighbor.jl")

_include_neighbor(@__FILE__)

end
