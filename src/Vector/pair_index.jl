function pair_index(an_)

    ty = eltype(an_)

    an_id = Dict{ty, Int}()

    id_an = Dict{Int, ty}()

    # TODO: Speed up.
    for (id, an) in enumerate(an_)

        an_id[an] = id

        id_an[id] = an

    end

    return an_id, id_an

end
