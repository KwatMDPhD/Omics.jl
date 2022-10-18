module Dict

using JSON: parse, print as JSON_print

using TOML: parsefile

using ..OnePiece

include("../_include.jl")

@_include()

end
