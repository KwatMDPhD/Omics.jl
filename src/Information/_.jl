module Information

using StatsBase: mean, std

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
