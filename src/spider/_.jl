module spider

import Base: >>

using ColorSchemes

using Colors

using ..OnePiece

VE_ = []

ED_ = []

include("add.jl")

include("load.jl")

include("plot.jl")

include("react.jl")

include("reset!.jl")

end
