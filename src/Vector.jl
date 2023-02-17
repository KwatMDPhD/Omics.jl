module Vector

function is_in(ne_, ha_)

    n = length(ne_)

    bo_ = Base.Vector{Bool}(undef, n)

    for id in 1:n

        bo_[id] = ne_[id] in ha_

    end

    return bo_

end

function is_in(ne_id::AbstractDict, ha_)

    bo_ = fill(false, length(ne_id))

    for ha in ha_

        # TODO: `haskey`.

        id = get(ne_id, ha, nothing)

        if !isnothing(id)

            bo_[id] = true

        end

    end

    return bo_

end

function sort_like(an__; de = false)

    so_ = sortperm(an__[1]; rev = de)

    return [an_[so_] for an_ in an__]

end

function sort_recursively(an)

    if an isa AbstractArray

        ans = [sort_recursively(an2) for an2 in an]

    elseif an isa AbstractDict

        ans = sort(OrderedDict(ke => sort_recursively(va) for (ke, va) in an))

    else

        ans = an

    end

    try

        if ans isa Tuple

            ans = Tuple(sort!(collect(ans)))

        end

        sort!(ans)

    catch

    end

    return ans

end

end
