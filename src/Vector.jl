module Vector

function is_in(an_, an1_)

    n = length(an_)

    bo_ = Base.Vector{Bool}(undef, n)

    for id in 1:n

        bo_[id] = an_[id] in an1_

    end

    return bo_

end

function is_in(an_id::AbstractDict, an1_)

    bo_ = fill(false, length(an_id))

    for an1 in an1_

        id = get(an_id, an1, nothing)

        if !isnothing(id)

            bo_[id] = true

        end

    end

    return bo_

end

function pair_index(an_)

    ty = eltype(an_)

    an_id = Dict{ty, Int}()

    id_an = Dict{Int, ty}()

    for (id, an) in enumerate(an_)

        an_id[an] = id

        id_an[id] = an

    end

    return an_id, id_an

end

function get_common_start(an__)

    le_ = [length(an_) for an_ in an__]

    mi = minimum(le_)

    sh = an__[findfirst(le == mi for le in le_)]

    id = 1

    while id <= mi

        an = sh[id]

        # TODO: Do not check the shortest one.
        if any(an_[id] != an for an_ in an__)

            break

        end

        id += 1

    end

    return sh[1:(id - 1)]

end

function sort_like(an__; de = false)

    so_ = sortperm(an__[1]; rev = de)

    return [an_[so_] for an_ in an__]

end

function sort_recursively(an)

    if an isa AbstractArray

        an = [sort_recursively(an2) for an2 in an]

    elseif an isa AbstractDict

        an = sort(Dict(ke => sort_recursively(va) for (ke, va) in an))

    else

        an = an

    end

    try

        if an isa Tuple

            an = Tuple(sort!(collect(an)))

        end

        # TODO: Check.
        sort!(an)

    catch

    end

    return an

end

end
