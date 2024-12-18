module Clustering

using Clustering: hclust

using Distances: pairwise

function hierarchize(di, linkage = :ward)

    hclust(di; linkage)

end

function order(fu, la_, nu___)

    io_ = Vector{Int}(undef, lastindex(la_))

    en = 0

    for la in sort!(unique(la_))

        il_ = findall(==(la), la_)

        io_[(en + 1):(en += lastindex(il_))] =
            il_[hierarchize(pairwise(fu, nu___[il_])).order]

    end

    io_

end

end
