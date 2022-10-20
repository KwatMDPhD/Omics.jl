function map_mouse()

    mo = OnePiece.Table.read(_path("ensembl.mouse_human.tsv.gz"))

    ke_va = Dict()

    for (ke, va) in eachrow(mo[!, ["Gene name", "Human gene name"]])

        if ismissing(ke) || ismissing(va)

            continue

        end

        OnePiece.Dict.set!(ke_va, ke => va, pr = false)

    end

    ke_va

end
