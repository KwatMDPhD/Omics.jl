module HTML

using DefaultApplication: open as DefaultApplication_open

using ..BioLab

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
