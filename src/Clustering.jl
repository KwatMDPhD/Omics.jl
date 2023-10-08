module Clustering

using Clustering: cutree, hclust

using Distances: Euclidean, pairwise

using ..BioLab

const _FU = Euclidean()

function hierarchize(ma, fu = _FU, linkage = :ward)

    hclust(pairwise(fu, ma); linkage)

end

function cluster(hc, k)

    cutree(hc; k)

end

function order(co_, ma, fu = _FU; ke_ar...)

    id_ = Vector{Int}()

    for co in BioLab.Collection.unique_sort(co_)

        idc_ = findall(==(co), co_)

        append!(id_, idc_[hierarchize(ma[:, idc_], fu; ke_ar...).order])

    end

    id_

end

end
