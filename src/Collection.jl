module Collection

using OrderedCollections: OrderedDict

using StatsBase: countmap

function count_sort_string(an_, mi = 1)

    join("$n $an.\n" for (an, n) in sort(countmap(an_); byvalue = true, rev = true) if mi <= n)

end

function get_minimum_maximum(an_)

    mi = ma = an_[1]

    for i1 in 2:lastindex(an_)

        an = an_[i1]

        if an < mi

            mi = an

        elseif ma < an

            ma = an

        end

    end

    mi, ma

end

function map_index2(an_)

    an_i1_ = OrderedDict{eltype(an_), Vector{Int}}()

    for (i1, an) in enumerate(an_)

        if !haskey(an_i1_, an)

            an_i1_[an] = Int[]

        end

        push!(an_i1_[an], i1)

    end

    an_i1_

end

function _map_index(an_)

    Dict(an => i1 for (i1, an) in enumerate(an_))

end

function count(an1_, an2_)

    an1_i1 = _map_index(unique(an1_))

    an2_i2 = _map_index(unique(an2_))

    co = zeros(Int, length(an1_i1), length(an2_i2))

    for (an1, an2) in zip(an1_, an2_)

        co[an1_i1[an1], an2_i2[an2]] += 1

    end

    co

end

end
