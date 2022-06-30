module figure

using JSON3
using ..OnePiece

include("plot.jl")

include("make_empty_trace.jl")

include("plot_x_y.jl")

include("plot_bar.jl")

include("plot_heat_map.jl")

end
