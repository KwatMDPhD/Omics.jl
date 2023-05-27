module Clustering

using Clustering: Hclust, cutree, hclust

using Distances: CorrDist, Euclidean, pairwise

function hierarchize(ma, dims; fu = Euclidean(), linkage = :ward)

    hclust(pairwise(fu, ma; dims); linkage)

end

function cluster(hi::Hclust, k)

    cutree(hi; k)

end

end
