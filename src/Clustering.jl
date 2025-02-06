module Clustering

using Clustering: hclust

using Distances: pairwise

function hierarchize(di, linkage = :ward)

    hclust(di; linkage)

end

function order(fu, gr_, an___)

    i1_ = Vector{Int}(undef, lastindex(gr_))

    id = 0

    for un in sort!(unique(gr_))

        i2_ = findall(==(un), gr_)

        i1_[(id + 1):(id += lastindex(i2_))] =
            i2_[hierarchize(pairwise(fu, an___[i2_])).order]

    end

    i1_

end

end
