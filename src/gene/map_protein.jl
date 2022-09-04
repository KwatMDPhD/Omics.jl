function map_protein()

    un = OnePiece.table.read(joinpath(@__DIR__, "uniprot.tsv.gz"))

    pr_di = Dict()

    na_ = names(un)

    for ro in eachrow(un)

        di = Dict()

        for (na, an) in zip(na_, ro)

            if na == "Entry Name"

                pr_di[split(an, "_HUMAN", limit = 2)[1]] = di

                continue

            end

            if !ismissing(an)

                if na == "Gene Names"

                    an = split(an, " ")

                elseif na == "Interacts with"

                    an = split(an, "; ")

                end

            end

            di[na] = an

        end

    end

    pr_di

end
