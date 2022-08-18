module spider

import Base: >>

using ColorSchemes

using Colors

using DataFrames

using LinearAlgebra

using StatsBase

using ..OnePiece

VERTEX_ = []

HEAT_ = []

EDGE_ = []

include("../_include_neighbor.jl")

_include_neighbor(@__FILE__)

end
