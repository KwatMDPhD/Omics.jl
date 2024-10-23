module Density

using ..Omics

function coun(nu_, ug)

    gr_ = Omics.Grid.make(nu_, ug)

    co_ = zeros(UInt, ug)

    for nu in nu_

        co_[Omics.Grid.find(gr_, nu)] += one(UInt)

    end

    gr_, co_

end

function coun(n1_, n2_, u1, u2)

    g1_ = Omics.Grid.make(n1_, u1)

    g2_ = Omics.Grid.make(n2_, u2)

    co = zeros(UInt, u1, u2)

    for id in eachindex(n1_)

        co[Omics.Grid.find(g1_, n1_[id]), Omics.Grid.find(g2_, n2_[id])] += one(UInt)

    end

    g1_, g2_, co

end

end
