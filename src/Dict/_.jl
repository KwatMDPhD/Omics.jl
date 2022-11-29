module Dict

using JSON: parse, print as JSON_print

using OrderedCollections: OrderedDict

using TOML: parsefile

using ..BioLab

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
