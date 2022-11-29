module Plot

using ColorSchemes: ColorScheme, plasma

using Colors: Colorant, hex

using DataFrames: DataFrame

using JSON3: write

using ..BioLab

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
