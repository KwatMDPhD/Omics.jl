module figure

using Cobweb

using PlotlyLight

include("make_empty_trace.jl")

include("plot.jl")

include("plot_bar.jl")

include("plot_heat_map.jl")

include("plot_x_y.jl")

include("plot_y.jl")

include("write.jl")

end
