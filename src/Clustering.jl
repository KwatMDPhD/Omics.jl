module Clustering

using Clustering: Hclust, cutree, hclust

using Distances: CorrDist, Euclidean, pairwise

function hierarchize(ma, dims; fu = Euclidean(), linkage = :ward)

    return hclust(pairwise(fu, ma; dims); linkage)

end

function cluster(hi::Hclust, k)

    return cutree(hi; k)

end

end
