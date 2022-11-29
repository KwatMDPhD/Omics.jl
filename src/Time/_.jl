module Time

using Dates: format, now

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
