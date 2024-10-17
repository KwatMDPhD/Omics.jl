module Density

using KernelDensity: default_bandwidth, kde

using ..Omics

function ge(n1_, n2_; ke_ar...)

    kd = kde((n1_, n2_); ke_ar...)

    kd.x, kd.y, kd.density

end

function grid(nu_, ug)

    mi, ma = extrema(nu_)

    range(mi, ma, ug)

end

function find(gr_, nu)

    id = 1

    while id < lastindex(gr_)

        if nu <= gr_[id]

            break

        end

        id += 1

    end

    id

end

function coun(nu_, ug::Integer)

    gr_ = grid(nu_, ug)

    co_ = zeros(UInt, ug)

    for nu in nu_

        co_[find(gr_, nu)] += one(UInt)

    end

    gr_, co_

end

function coun(n1_, n2_, (u1, u2)::Tuple{<:Integer, <:Integer})

    g1_ = grid(n1_, u1)

    g2_ = grid(n2_, u2)

    co = zeros(UInt, u1, u2)

    for id in eachindex(n1_)

        co[find(g1_, n1_[id]), find(g2_, n2_[id])] += one(UInt)

    end

    g1_, g2_, co

end

function coun(a1_, a2_, (a1_i1, a2_i2))

    co = zeros(UInt, length(a1_i1), length(a2_i2))

    for id in eachindex(a1_)

        co[a1_i1[a1_[id]], a2_i2[a2_[id]]] += one(UInt)

    end

    k1_ = collect(keys(a1_i1))

    k2_ = collect(keys(a2_i2))

    i1_ = sortperm(k1_)

    i2_ = sortperm(k2_)

    k1_[i1_], k2_[i2_], co[i1_, i2_]

end

end
