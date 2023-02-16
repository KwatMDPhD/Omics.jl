function map_mouse()

    ke_va = Dict{String, String}()

    fe_x_in_x_an = BioLab.Table.read(_path("ensembl.mouse_human.tsv.gz"))

    for (ke, va) in zip(fe_x_in_x_an[!, "Gene name"], fe_x_in_x_an[!, "Human gene name"])

        if ismissing(ke) || ismissing(va)

            continue

        end

        BioLab.Dict.set_with_last!(ke_va, ke, va)

    end

    return ke_va

end
