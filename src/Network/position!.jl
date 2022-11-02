function position!(ke_va_, id_kec_vac)

    for ke_va in ke_va_

        po = "position"

        ke_va[po] = id_kec_vac[ke_va["data"]["id"]][po]

    end

    nothing

end

function position!(ke_va_, js::AbstractString)

    position!(
        ke_va_,
        Dict(
            pop!(kec_vac["data"], "id") => kec_vac for
            kec_vac in OnePiece.Dict.read(js)["elements"]["nodes"]
        ),
    )

end
