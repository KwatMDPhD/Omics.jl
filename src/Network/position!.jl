function position!(ve_, id_di)

    for ve in ve_

        da = ve["data"]

        ke = "position"

        ve[ke] = id_di[string(da["id"])][ke]

    end

    nothing

end

function position!(ve_, js::AbstractString)

    position!(
        ve_,
        Dict(di["data"]["id"] => di for di in OnePiece.Dict.read(js)["elements"]["nodes"]),
    )

end
