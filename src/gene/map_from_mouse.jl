function map_from_mouse()

    or = OnePiece.table.read(joinpath(@__DIR__, "ensembl.mouse_human.tsv.gz"))

    co_ = ["Gene name", "Human gene name"]

    dropmissing!(or, co_)

    ke_va = Dict()

    for ro in eachrow(or)

        ke, va = ro[co_]

        if haskey(ke_va, ke)

            continue

        end

        ke_va[ke] = va

    end

    ke_va

end
