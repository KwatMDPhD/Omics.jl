module Protein

using ..Omics

const _UN = pkgdir(Omics, "data", "Protein", "uniprot.tsv.gz")

function _string(an)

    ismissing(an) ? "" : an

end

function map_uniprot()

    un = Omics.Table.rea(_UN)

    pr_ = un[!, 2]

    di = Dict{eltype(pr_), Dict{String, String}}()

    ke_ = names(un)[vcat(1, 3:end)]

    va = Matrix(un[!, ke_])

    for i1 in eachindex(pr_)

        di[pr_[i1][1:(end - 6)]] =
            Dict(ke_[i2] => _string(va[i1, i2]) for i2 in eachindex(ke_))

    end

    di

end

end
