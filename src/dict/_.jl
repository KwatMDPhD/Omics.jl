module dict

using JSON

using OrderedCollections

using TOML

INDENT = 3

include("../include_neighbor.jl")

include_neighbor(@__FILE__)

end
