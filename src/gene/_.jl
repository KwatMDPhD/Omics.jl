module gene

using DataFrames
using ..OnePiece

include("map_from_mouse.jl")

include("map_to_ensembl.jl")

include("map_to_hgnc.jl")

include("read_ensembl.jl")

include("read_hgnc.jl")

include("rename.jl")

end
