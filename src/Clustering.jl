module Clustering

using Clustering: hclust

using Distances: pairwise

using ..Omics

function hierarchize(di, linkage = :ward)

    hclust(di; linkage)

end

function order(fu, la_, nu___)

    id_ = Vector{Int}(undef, lastindex(la_))

    en = 0

    for la in sort!(unique(la_))

        il_ = findall(==(la), la_)

        id_[(en + 1):(en += lastindex(il_))] =
            il_[hierarchize(pairwise(fu, nu___[il_])).order]

    end

    id_

end

end
