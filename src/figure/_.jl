module figure

using JSON3
using ..OnePiece

include("_make_empty_trace.jl")

include("plot.jl")

include("plot_bar.jl")

include("plot_heat_map.jl")

include("plot_x_y.jl")

end
