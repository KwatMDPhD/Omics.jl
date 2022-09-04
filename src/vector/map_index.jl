# TODO: Add to .ipynb
function map_index(an_)

    an_id = Dict()

    id_an = Dict()

    for (id, an) in enumerate(an_)

        an_id[an] = id

        id_an[id] = an

    end

    an_id, id_an

end
