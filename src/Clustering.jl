module Clustering

using Clustering: hclust

using Distances: pairwise

function hierarchize(di, linkage = :ward)

    hclust(di; linkage)

end

function order(fu, gr_, an___)

    io_ = Vector{Int}(undef, lastindex(gr_))

    ie = 0

    for gr in sort!(unique(gr_))

        ig_ = findall(==(gr), gr_)

        io_[(ie + 1):(ie += lastindex(ig_))] =
            ig_[hierarchize(pairwise(fu, an___[ig_])).order]

    end

    io_

end

end
