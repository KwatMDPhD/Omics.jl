module dict

using JSON
using OrderedCollections
using TOML

IN = 3

include("make.jl")

include("merge.jl")

include("read.jl")

include("sort_recursively!.jl")

include("summarize.jl")

include("symbolize.jl")

include("view.jl")

include("write.jl")

end
