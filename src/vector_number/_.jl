module vector_number

using Distributions
using Random
using ..OnePiece

include("cumulate_sum_reverse.jl")

include("get_area.jl")

include("get_extreme.jl")

include("make_increasing_by_stepping_down!.jl")

include("make_increasing_by_stepping_up!.jl")

include("shift_minimum.jl")

include("simulate.jl")

end
