module spider

import Base: >>

using ..OnePiece

VE_ = []

ED_ = []

include("add.jl")

include("load.jl")

include("plot.jl")

include("react.jl")

include("reset!.jl")

end
