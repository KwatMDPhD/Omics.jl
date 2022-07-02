module dict

using JSON
using OrderedCollections
using TOML

IN = 3

include("make.jl")

include("merge.jl")

include("print.jl")

include("read.jl")

include("sort_recursively!.jl")

include("symbolize.jl")

include("write.jl")

end
