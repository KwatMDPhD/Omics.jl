module OnePiece

include("constant/_.jl")

include("data_frame/_.jl")

include("dict/_.jl")

include("feature_set_enrichment/_.jl")

include("feature_x_sample/_.jl")

include("figure/_.jl")

include("fu/_.jl")

include("gct/_.jl")

include("gene/_.jl")

include("gmt/_.jl")

include("html/_.jl")

include("information/_.jl")

include("ipynb/_.jl")

include("matrix/_.jl")

include("network/_.jl")

include("normalization/_.jl")

include("number/_.jl")

include("path/_.jl")

include("significance/_.jl")

include("statistics/_.jl")

include("string/_.jl")

include("table/_.jl")

include("time/_.jl")

include("vector/_.jl")

include("vector_number/_.jl")

function __init__()

    global TEMPORARY_DIRECTORY = OnePiece.path.make_temporary("OnePiece")

end

end
