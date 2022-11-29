module Statistics

using Distributions: Normal, quantile

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
