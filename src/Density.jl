module Density

using ..Omics

function coun(nu_, u1)

    gr_ = Omics.Grid.make(nu_, u1)

    u2_ = zeros(Int, u1)

    for nu in nu_

        u2_[Omics.Grid.find(gr_, nu)] += 1

    end

    gr_, u2_

end

function coun(n1_, n2_, u1, u2)

    g1_ = Omics.Grid.make(n1_, u1)

    g2_ = Omics.Grid.make(n2_, u2)

    u3 = zeros(Int, u1, u2)

    for id in eachindex(n1_)

        u3[Omics.Grid.find(g1_, n1_[id]), Omics.Grid.find(g2_, n2_[id])] += 1

    end

    g1_, g2_, u3

end

end
