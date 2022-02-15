module gene

using DataFrames

using ..OnePiece

include("map_to_ensembl_gene.jl")

include("map_to_hgnc_gene.jl")

include("map_with_mouse.jl")

include("read_ensembl.jl")

include("read_hgnc.jl")

include("rename.jl")

end
