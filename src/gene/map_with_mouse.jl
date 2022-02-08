function map_with_mouse(; ho="mouse_to_human")

    if ho == "mouse_to_human"

        ke = "Gene name"

        va = "Human gene name"

        hu = va

    elseif ho == "human_to_mouse"

        ke = "Gene name"

        va = "Mouse gene name"

        hu = ke

    end

    or = read(joinpath(@__DIR__, string("ensembl.", ho, ".tsv.gz")))

    dropmissing!(or, [ke, va])

    or[!, hu] = rename(or[!, hu]; mo = false)[1]

    ke_va = Dict(ro[ke] => ro[va] for ro in eachrow(or))

    summarize(ke_va)

    return ke_va

end
