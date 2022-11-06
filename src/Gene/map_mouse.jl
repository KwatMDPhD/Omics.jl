function map_mouse()

    ke_va = Dict()

    fe_x_in_x_an = OnePiece.Table.read(_path("ensembl.mouse_human.tsv.gz"))

    for (ke, va) in zip(fe_x_in_x_an[!, "Gene name"], fe_x_in_x_an[!, "Human gene name"])

        if ismissing(ke) || ismissing(va)

            continue

        end

        OnePiece.Dict.set!(ke_va, ke, va, pr = false)

    end

    ke_va

end
