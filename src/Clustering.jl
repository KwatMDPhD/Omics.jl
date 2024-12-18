module Clustering

using Clustering: hclust

using Distances: pairwise

using ..Omics

function hierarchize(di, linkage = :ward)

    hclust(di; linkage)

end

function order(fu, la_, nu___)

    id_ = Vector{Int}(undef, lastindex(la_))

    st = 1

    for la in sort!(unique(la_))

        il_ = findall(==(la), la_)

        en = st + lastindex(il_) - 1

        id_[st:en] = il_[hierarchize(pairwise(fu, nu___[il_])).order]

        st = en + 1

    end

    id_

end

end
