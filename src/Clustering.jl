module Clustering

using Clustering: cutree, hclust

using Distances: Euclidean, pairwise

const _FU = Euclidean()

const _LI = :ward

function hierarchize(ma, fu = _FU, linkage = _LI)

    hclust(pairwise(fu, ma); linkage)

end

function cluster(hc, k)

    cutree(hc; k)

end

function order(co_, ma, fu = _FU, linkage = _LI)

    id_ = Vector{Int}()

    for co in sort!(unique(co_))

        idc_ = findall(==(co), co_)

        append!(id_, view(idc_, hierarchize(ma[:, idc_], fu, linkage).order))

    end

    id_

end

end
