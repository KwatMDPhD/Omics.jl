module Clustering

using Clustering: Hclust, cutree, hclust

using Distances: CorrDist, Euclidean, pairwise

function hierarchize(ro_x_co_x_nu, dims; fu = Euclidean(), linkage = :ward)

    return hclust(pairwise(fu, ro_x_co_x_nu; dims); linkage)

end

function cluster(hi::Hclust, k)

    return cutree(hi; k)

end

end
