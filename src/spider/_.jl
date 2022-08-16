module spider

import Base: >>

using ColorSchemes

using Colors

using DataFrames

using LinearAlgebra

using ..OnePiece

VERTEX_ = []

HEAT_ = []

EDGE_ = []

include("add.jl")

include("edge.jl")

println(HEAT_)
include("flow.jl")

include("heat.jl")

include("highlight.jl")

include("load.jl")

include("plot.jl")

include("react.jl")

include("reset!.jl")

end
