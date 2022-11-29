module Clustering

using Clustering: Hclust, cutree, hclust

using Distances: Euclidean, pairwise

include(joinpath(pkgdir(@__MODULE__), "src", "_include.jl"))

@_include()

end
