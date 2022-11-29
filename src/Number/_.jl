module Number

using Printf: @sprintf

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
