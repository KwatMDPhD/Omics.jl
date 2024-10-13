module Density

using ..Omics

function grid(nu_, ug)

    mi, ma = extrema(nu_)

    range(mi, ma, ug)

end

function _find(gr_, nu)

    id = 1

    while id < lastindex(gr_)

        if nu <= gr_[id]

            break

        end

        id += 1

    end

    id

end

function coun(n1_, ug::Integer)

    g1_ = grid(n1_, ug)

    co = zeros(UInt, ug)

    for id in eachindex(n1_)

        co[_find(g1_, n1_[id])] += 1

    end

    g1_, co

end

function coun(n1_, n2_, ug::Integer)

    if !(lastindex(n1_) == lastindex(n2_))

        error()

    end

    g1_ = grid(n1_, ug)

    g2_ = grid(n2_, ug)

    co = zeros(UInt, ug, ug)

    for id in eachindex(n1_)

        co[_find(g1_, n1_[id]), _find(g2_, n2_[id])] += 1

    end

    g1_, g2_, co

end

function coun(a1_, a2_)

    if !(lastindex(a1_) == lastindex(a2_))

        error()

    end

    a1_i1 = Omics.Dic.index(a1_)

    a2_i2 = Omics.Dic.index(a2_)

    co = zeros(UInt, length(a1_i1), length(a2_i2))

    for id in eachindex(a1_)

        co[a1_i1[a1_[id]], a2_i2[a2_[id]]] += 1

    end

    co

end

end
