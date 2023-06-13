module Gene

using ..BioLab

function _read(fi)

    BioLab.Table.read(joinpath(dirname(@__DIR__), "data", "Gene", fi))

end

function read_ensembl()

    _read("ensembl.tsv.gz")

end

function read_uniprot()

    _read("uniprot.tsv.gz")

end

function map_ensembl(feature_x_information_x_anything = read_ensembl())

    BioLab.DataFrame.map_to(
        feature_x_information_x_anything,
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

function map_uniprot(protein_x_information_x_anything = read_uniprot())

    pr_io_an = Dict{String, Dict{String, Any}}()

    io_ = names(protein_x_information_x_anything)

    for an_ in eachrow(protein_x_information_x_anything)

        io_an = Dict{String, Any}()

        for (io, an) in zip(io_, an_)

            if ismissing(an)

                continue

            end

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

# TODO: Move to Dict.
function rename(na1_, na1_na2)

    n = length(na1_)

    na2_ = Vector{String}(undef, n)

    ma_ = Vector{Int}(undef, n)

    n1 = n2 = n3 = 0

    for (id, na1) in enumerate(na1_)

        if haskey(na1_na2, na1)

            na2 = na1_na2[na1]

            if na1 == na2

                ma = 1

                n1 += 1

            else

                ma = 2

                n2 += 1

            end

        else

            na2 = na1

            ma = 3

            n3 += 1

        end

        na2_[id] = na2

        ma_[id] = ma

    end

    @info "Already renamed $n1. Renamed $n2. Failed $n3."

    na2_, ma_

end

end
