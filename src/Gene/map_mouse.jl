function map_mouse(; pr = true)

    mo = OnePiece.Table.read(_path("ensembl.mouse_human.tsv.gz"))

    ke_va = Dict()

    for (ke, va) in eachrow(mo[!, ["Gene name", "Human gene name"]])

        if ismissing(ke) || ismissing(va)

            continue

        end

        cu = get!(ke_va, ke, va)

        if cu != va

            if pr

                println("$ke => $cu (=> $va)")

            end

            continue

        end

    end

    ke_va

end
