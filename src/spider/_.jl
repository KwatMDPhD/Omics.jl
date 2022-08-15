module spider

import Base: >>

using ColorSchemes

using Colors

using ..OnePiece

VERTEX_ = []

EDGE_ = []

include("add.jl")

include("load.jl")

include("plot.jl")

include("react.jl")

include("reset!.jl")

end
