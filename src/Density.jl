module Density

using ..Omics

function grid(nu_, ug)

    mi, ma = extrema(nu_)

    range(mi, ma, ug)

end

function find(gr_, nu)

    # TODO: Take advantage of the order.
    findmin(gr -> abs(gr - nu), gr_)[2]

end

function coun(n1_, ug::Integer)

    g1_ = grid(n1_, ug)

    co = zeros(ug)

    for ip in eachindex(n1_)

        co[find(g1_, n1_[ip])] += 1

    end

    g1_, co

end

function coun(n1_, n2_, ug::Integer)

    if !(lastindex(n1_) == lastindex(n2_))

        error()

    end

    g1_ = grid(n1_, ug)

    g2_ = grid(n2_, ug)

    co = zeros(ug, ug)

    for ip in eachindex(n1_)

        co[find(g1_, n1_[ip]), find(g2_, n2_[ip])] += 1

    end

    g1_, g2_, co

end

function coun(a1_, a2_)

    if !(lastindex(a1_) == lastindex(a2_))

        error()

    end

    a1_i1 = Omics.Dic.index(a1_)

    a2_i2 = Omics.Dic.index(a2_)

    co = zeros(length(a1_i1), length(a2_i2))

    for ip in eachindex(a1_)

        co[a1_i1[a1_[ip]], a2_i2[a2_[ip]]] += 1.0

    end

    co

end

end
