module figure

using JSON3
using Scratch
using ..OnePiece

function __init__()

    global SC = @get_scratch!("figure")

end

include("plot.jl")

include("view.jl")

include("make_empty_trace.jl")

include("plot_x_y.jl")

include("plot_bar.jl")

include("plot_heat_map.jl")

end
