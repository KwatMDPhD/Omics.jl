module Gene

using BioLab

function map_ensembl()

    BioLab.DataFrame.map(
        BioLab.Table.read(joinpath(BioLab.DA, "Gene", "ensembl.tsv.gz")),
        BioLab.Dict.set_with_last!,
        [
            "Transcript stable ID version",
            "Transcript stable ID",
            "Transcript name",
            "Gene stable ID version",
            "Gene stable ID",
        ],
        "Gene name";
        de = '|',
    )

end

function map_uniprot()

    pr_co_an = Dict{String, Dict{String, Any}}()

    da = BioLab.Table.read(joinpath(BioLab.DA, "Gene", "uniprot.tsv.gz"))

    co_ = names(da)

    for an_ in eachrow(da)

        co_an = Dict{String, Any}()

        for (co, an) in zip(co_, an_)

            if BioLab.Bad.is_bad(an)

                continue

            end

            # TODO: If Entry Name is the first column, decouple setting it and the rest of the columns.
            if co == "Entry Name"

                if !endswith(an, "_HUMAN")

                    error("$an lacks _HUMAN.")

                end

                BioLab.Dict.set_with_last!(pr_co_an, chop(an; tail = 6), co_an)

            else

                if co == "Gene Names"

                    an = split(an)

                elseif co == "Interacts with"

                    an = split(an, "; ")

                end

                co_an[co] = an

            end

        end

    end

    pr_co_an

end

end
