module Gene

using BioLab

function map_ensembl()

    sp_to = Dict{String, String}()

    ma = Matrix(
        BioLab.Table.read(
            joinpath(BioLab._DA, "Gene", "ensembl.tsv.gz");
            select = [
                "Transcript stable ID version",
                "Transcript stable ID",
                "Transcript name",
                "Gene stable ID version",
                "Gene stable ID",
                "Gene name",
            ],
        ),
    )

    n = size(ma, 2)

    for an_ in eachrow(ma)

        to = an_[n]

        if BioLab.Bad.is(to)

            continue

        end

        for fr in view(an_, 1:(n - 1))

            if BioLab.Bad.is(fr)

                continue

            end

            for sp in eachsplit(fr, '|')

                BioLab.Dict.set!(sp_to, sp, to)

            end

        end

    end

    sp_to

end

function map_uniprot()

    pr_co_an = Dict{String, Dict{String, Any}}()

    da = BioLab.Table.read(joinpath(BioLab._DA, "Gene", "uniprot.tsv.gz"))

    co_ = names(da)

    for an_ in eachrow(Matrix(da))

        co_an = Dict{String, Any}()

        for (co, an) in zip(co_, an_)

            if BioLab.Bad.is(an)

                continue

            end

            if co == "Entry Name"

                BioLab.Dict.set!(pr_co_an, chop(an; tail = 6), co_an)

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
