module spider

import Base: >>

using ColorSchemes

using Colors

using DataFrames

using LinearAlgebra

using Statistics

using ..OnePiece

VERTEX_ = []

HEAT_ = []

EDGE_ = []

include("../include_neighbor.jl")

include_neighbor(@__FILE__)

end
