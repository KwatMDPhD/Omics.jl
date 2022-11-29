module MatrixFactorization

using LinearAlgebra: pinv

using NMF: nnmf

using ..BioLab

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
