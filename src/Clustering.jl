module Clustering

using Clustering: Hclust, cutree, hclust

using Distances: CorrDist, Euclidean, pairwise

function hierarchize(ro_x_co_x_nu, di; fu = Euclidean(), li = :ward)

    return hclust(pairwise(fu, ro_x_co_x_nu; dims = di); linkage = li)

end

function cluster(hi::Hclust, n)

    return cutree(hi; k = n)

end

end
