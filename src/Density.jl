module Density

function grid(nu_, ug)

    mi, ma = extrema(nu_)

    range(mi, ma, ug)

end

function find(gr_, nu)

    for id in eachindex(gr_)

        if nu <= gr_[id]

            return id

        end

    end

    lastindex(gr_)

end

function coun(nu_, ug)

    gr_ = grid(nu_, ug)

    co_ = zeros(UInt, ug)

    for nu in nu_

        co_[find(gr_, nu)] += one(UInt)

    end

    gr_, co_

end

function coun(n1_, n2_, u1, u2)

    g1_ = grid(n1_, u1)

    g2_ = grid(n2_, u2)

    co = zeros(UInt, u1, u2)

    for id in eachindex(n1_)

        co[find(g1_, n1_[id]), find(g2_, n2_[id])] += one(UInt)

    end

    g1_, g2_, co

end

end
