function position!(el_, js)

    id_di =
        Dict(di["data"]["id"] => di for di in vcat(values(OnePiece.dict.read(js)["elements"])...))

    for el in el_

        da = el["data"]

        ke = "position"

        el[ke] = id_di[da["id"]][ke]

    end

    el_

end
