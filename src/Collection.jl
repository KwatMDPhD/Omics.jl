module Collection

using OrderedCollections: OrderedDict

using StatsBase: countmap

using ..BioLab

function count_sort(an_; rev = false)

    sort(countmap(an_); byvalue = true, rev)

end

function get_extreme(n::Int, n_ex)

    if n < n_ex

        n_ex = n

    end

    n_ex2 = n - n_ex + 1

    if !(n_ex < n_ex2)

        n_ex2 = n_ex + 1

    end

    vcat(collect(1:n_ex), collect(n_ex2:n))

end

function get_extreme(an_, n_ex)

    sortperm(an_)[get_extreme(length(an_), n_ex)]

end

function is_in(an_, an1_)

    n = length(an_)

    bo_ = Vector{Bool}(undef, n)

    for id in 1:n

        bo_[id] = an_[id] in an1_

    end

    bo_

end

function is_in(an_id::AbstractDict, an1_)

    bo_ = fill(false, length(an_id))

    for an1 in an1_

        id = get(an_id, an1, 0)

        if !iszero(id)

            bo_[id] = true

        end

    end

    bo_

end

function index(an_)

    ty = eltype(an_)

    an_id = Dict{ty, Int}()

    id_an = Dict{Int, ty}()

    for (id, an) in enumerate(an_)

        an_id[an] = id

        id_an[id] = an

    end

    an_id, id_an

end

function get_type(an___)

    eltype(vcat(an___...))

end

function sort_like(an___; rev = false)

    id_ = sortperm(an___[1]; rev)

    (an_[id_] for an_ in an___)

end

function get_common_start(an___)

    ans = an___[1]

    les = length(ans)

    for an_ in an___[2:end]

        le = length(an_)

        if le < les

            ans = an_

            les = le

        end

    end

    for (id, an) in enumerate(ans)

        if any(an_[id] != an for an_ in an___)

            return ans[1:(id - 1)]

        end

    end

    ans

end

function sort_recursively(co)

    if co isa AbstractArray

        co = [sort_recursively(an2) for an2 in co]

    elseif co isa AbstractDict

        co = sort!(OrderedDict(ke => sort_recursively(va) for (ke, va) in co))

    end

    try

        sort!(co)

    catch

    end

    co

end

end
