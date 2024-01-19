module Collection

using OrderedCollections: OrderedDict

using StatsBase: countmap

function get_minimum_maximum(an_)

    mi = ma = an_[1]

    for id in 2:lastindex(an_)

        an = an_[id]

        if an < mi

            mi = an

        elseif ma < an

            ma = an

        end

    end

    mi, ma

end

# TODO: Test.
function find(an, an_)

    findfirst(==(an), an_)

end

function _map_index(an_)

    Dict(an => id for (id, an) in enumerate(an_))

end

function map_index(an_)

    an_id_ = OrderedDict{eltype(an_), Vector{Int}}()

    for (id, an) in enumerate(an_)

        if !haskey(an_id_, an)

            an_id_[an] = Int[]

        end

        push!(an_id_[an], id)

    end

    an_id_

end

function count(an1_, an2_)

    an1_id = _map_index(unique(an1_))

    an2_id = _map_index(unique(an2_))

    co = zeros(Int, length(an1_id), length(an2_id))

    for (an1, an2) in zip(an1_, an2_)

        co[an1_id[an1], an2_id[an2]] += 1

    end

    co

end

function count_sort_string(an_, mi = 1)

    join("$n $an.\n" for (an, n) in sort(countmap(an_); byvalue = true, rev = true) if mi <= n)

end

end
