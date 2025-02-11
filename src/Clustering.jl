module Clustering

using Clustering: hclust

using Distances: pairwise

function hierarchize(di)

    hclust(di; linkage = :ward, branchorder = :barjoseph)

end

function order(fu, gr_, an___)

    i1_ = Vector{Int}(undef, lastindex(gr_))

    i2 = 0

    for un in sort!(unique(gr_))

        i3_ = findall(==(un), gr_)

        i1_[(i2 + 1):(i2 += lastindex(i3_))] =
            i3_[hierarchize(pairwise(fu, an___[i3_])).order]

    end

    i1_

end

end
