function map_mouse(; di::String = "mouse_to_human")::Dict{String,String}

    if di == "mouse_to_human"

        ke = "Gene name"

        va = "Human gene name"

        hu = va

    elseif di == "human_to_mouse"

        ke = "Gene name"

        va = "Mouse gene name"

        hu = ke

    end

    or = TableAccess.read(joinpath(DA, string("ensembl.", di, ".tsv.gz")))

    dropmissing!(or, [ke, va])

    or[!, hu] = Gene.rename(convert(Vector{String}, or[!, hu]); mo = false)[1]

    ke_va = Dict(ro[ke] => ro[va] for ro in eachrow(or))

    println(length(ke_va))

    return ke_va

end
