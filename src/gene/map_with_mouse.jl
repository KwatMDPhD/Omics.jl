function map_with_mouse()

    or = OnePiece.table.read(joinpath(@__DIR__, "ensembl.mouse_human.tsv.gz"))

    ke = "Gene name"

    va = "Human gene name"

    dropmissing!(or, [ke, va])

    ke_va = Dict(ro[ke] => ro[va] for ro in eachrow(or))

    OnePiece.dict.summarize(ke_va)

    ke_va

end
