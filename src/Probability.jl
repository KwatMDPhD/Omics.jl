module Probability

using KernelDensity: default_bandwidth, kde

function grid(nu_, ug)

    mi, ma = extrema(nu_)

    range(mi, ma, ug)

end

function find_index(gr_, nu)

    # TODO: Take advantage of the order.
    findmin(gr -> abs(gr - nu), gr_)[2]

end

function count(n1_, ug::Integer)

    g1_ = grid(n1_, ug)

    co = zeros(ug)

    for ip in eachindex(n1_)

        co[find_index(g1_, n1_[ip])] += 1

    end

    g1_, co

end

function count(n1_, n2_, ug::Integer)

    if !(lastindex(n1_) == lastindex(n2_))

        error()

    end

    g1_ = grid(n1_, ug)

    g2_ = grid(n2_, ug)

    co = zeros(ug, ug)

    for ip in eachindex(n1_)

        co[find_index(g1_, n1_[ip]), find_index(g2_, n2_[ip])] += 1

    end

    g1_, g2_, co

end

function map_index(an_)

    an_id = Dict{eltype(an_), UInt16}()

    id = 0

    for an in an_

        if !haskey(an_id, an)

            an_id[an] = id += 1

        end

    end

    an_id

end

function count(a1_, a2_)

    if !(lastindex(a1_) == lastindex(a2_))

        error()

    end

    a1_i1 = map_index(a1_)

    a2_i2 = map_index(a2_)

    co = zeros(length(a1_i1), length(a2_i2))

    for ip in eachindex(a1_)

        co[a1_i1[a1_[ip]], a2_i2[a2_[ip]]] += 1.0

    end

    co

end

function _01!(co)

    su = sum(co)

    map!(nu -> nu / su, co, co)

end

end
