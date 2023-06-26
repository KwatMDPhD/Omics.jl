module Gene

using ..BioLab

function _read(gz)

    BioLab.Table.read(joinpath(BioLab.DA, "Gene", gz))

end

function read_ensembl()

    _read("ensembl.tsv.gz")

end

function read_uniprot()

    _read("uniprot.tsv.gz")

end

function map_ensembl(da = read_ensembl())

    BioLab.DataFrame.map_to(
        da,
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

function map_uniprot(da = read_uniprot())

    pr_io_an = Dict{String, Dict{String, Any}}()

    io_ = names(da)

    for an_ in eachrow(da)

        io_an = Dict{String, Any}()

        for (io, an) in zip(io_, an_)

            if ismissing(an)

                continue

            end

            # TODO: If Entry Name is the first column, decouple setting it and the rest of the columns.
            if io == "Entry Name"

                if !endswith(an, "_HUMAN")

                    error("$an lacks _HUMAN.")

                end

                BioLab.Dict.set_with_last!(pr_io_an, an[1:(end - 6)], io_an)

            else

                if io == "Gene Names"

                    an = split(an)

                elseif io == "Interacts with"

                    an = split(an, "; ")

                end

                io_an[io] = an

            end

        end

    end

    pr_io_an

end

end
