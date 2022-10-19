function map_protein()

    un = OnePiece.Table.read(_path("uniprot.tsv.gz"))

    pr_di = Dict()

    co_ = names(un)

    for ro in eachrow(un)

        di = Dict()

        for (co, an) in zip(co_, ro)

            if co == "Entry Name"

                pr = split(an, "_HUMAN", limit = 2)[1]

                if haskey(pr_di, pr)

                    error()

                end

                pr_di[pr] = di

                continue

            end

            if an isa AbstractString

                if co == "Gene Names"

                    an = split(an, " ")

                elseif co == "Interacts with"

                    an = split(an, "; ")

                end

            end

            di[co] = an

        end

    end

    pr_di

end
