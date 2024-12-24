module Clustering

using Clustering: hclust

using Distances: pairwise

function hierarchize(di, linkage = :ward)

    hclust(di; linkage)

end

function order(fu, gr_, an___)

    id_ = Vector{Int}(undef, lastindex(gr_))

    en = 0

    for gr in sort!(unique(gr_))

        ig_ = findall(==(gr), gr_)

        id_[(en + 1):(en += lastindex(ig_))] =
            ig_[hierarchize(pairwise(fu, an___[ig_])).order]

    end

    id_

end

end
