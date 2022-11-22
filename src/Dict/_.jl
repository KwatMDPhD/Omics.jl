module Dict

using JSON: parse, print as JSON_print

using OrderedCollections: OrderedDict

using TOML: parsefile

using ..BioinformaticsCore

include("../_include.jl")

@_include()

end
