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

include("add.jl")

include("edge.jl")

include("flow.jl")

include("heat.jl")

include("heat_check.jl")

include("highlight.jl")

include("load.jl")

include("plot.jl")

include("react.jl")

include("reset!.jl")

end
