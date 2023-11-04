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

function count_sort_string(an_, mi = 1)

    join("$n $an.\n" for (an, n) in sort(countmap(an_); byvalue = true, rev = true) if mi <= n)

end

end
