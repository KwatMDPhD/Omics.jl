module Clustering

using Clustering: cutree, hclust

using Distances: Euclidean, pairwise

function hierarchize(ma, dims; fu = Euclidean(), linkage = :ward)

    hclust(pairwise(fu, ma; dims); linkage)

end

function cluster(hi, k)

    cutree(hi; k)

end

end
