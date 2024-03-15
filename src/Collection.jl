module Collection

using OrderedCollections: OrderedDict

using StatsBase: countmap

function count_sort_string(an_, mi = 1)

    an_na = countmap(an_)

    join(
        "$(rpad(na, 8))$an.\n" for (an, na) in sort(an_na; by = an -> (an_na[an], an)) if mi <= na
    )

end

function log_unique(na_, an___)

    for id in sortperm(an___; by = an_ -> lastindex(unique(an_)), rev = true)

        @info "🔦 ($id) $(na_[id])\n$(count_sort_string(an___[id]))"

    end

end

function rename!(an_, an_a2)

    nr = 0

    for (id, an) in enumerate(an_)

        if haskey(an_a2, an)

            nr += 1

            a2 = an_a2[an]

        else

            a2 = "_$an"

        end

        an_[id] = a2

    end

    @info "📛 Renamed $nr / $(lastindex(an_))."

    if iszero(nr)

        error()

    end

end

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

function map_index2(an_)

    an_id_ = OrderedDict{eltype(an_), Vector{Int}}()

    for (id, an) in enumerate(an_)

        if !haskey(an_id_, an)

            an_id_[an] = Int[]

        end

        push!(an_id_[an], id)

    end

    an_id_

end

function _map_index(an_)

    Dict(an => id for (id, an) in enumerate(an_))

end

function count(a1_, a2_)

    a1_i1 = _map_index(unique(a1_))

    a2_i2 = _map_index(unique(a2_))

    aa = zeros(Int, length(a1_i1), length(a2_i2))

    for (a1, a2) in zip(a1_, a2_)

        aa[a1_i1[a1], a2_i2[a2]] += 1

    end

    aa

end

end
