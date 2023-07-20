module Gene

using BioLab

function map_ensembl()

    en_na = Dict{String, String}()

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

                en_na[sp] = to

            end

        end

    end

    en_na

end

function map_uniprot()

    pr_di = Dict{String, Dict{String, Any}}()

    da = BioLab.Table.read(joinpath(BioLab._DA, "Gene", "uniprot.tsv.gz"))

    co_ = names(da)

    id = 2

    popat!(co_, id)

    for (ro, an_) in zip(da[!, id], eachrow(Matrix(da[!, co_])))

        co_an = Dict{String, Any}()

        for (co, an) in zip(co_, an_)

            if BioLab.Bad.is(an)

                continue

            end

            if co == "Gene Names"

                an = split(an)

            elseif co == "Interacts with"

                an = split(an, "; ")

            end

            co_an[co] = an

        end

        pr = chop(ro; tail = 6)

        if haskey(pr_di, pr)

            error("$pr already exists.")

        end

        pr_di[pr] = co_an

    end

    pr_di

end

end
