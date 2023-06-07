module Gene

using ..BioLab

function _read(fi)

    BioLab.Table.read(joinpath(dirname(@__DIR__), "data", "Gene", fi))

end

function read_mouse()

    _read("ensembl.mouse_human.tsv.gz")

end

function read_ensembl()

    _read("ensembl.tsv.gz")

end

function read_hgnc()

    _read("hgnc_complete_set.tsv.gz")

end

function read_uniprot()

    _read("uniprot.tsv.gz")

end

function map_mouse(fe_x_io_x_an = read_mouse())

    BioLab.DataFrame.map_to(
        fe_x_io_x_an,
        BioLab.Dict.set_with_last!,
        ["Gene name"],
        "Human gene name",
    )

end

function map_ensembl(fe_x_io_x_an = read_ensembl())

    BioLab.DataFrame.map_to(
        fe_x_io_x_an,
        BioLab.Dict.set_with_last!,
        [
            "Transcript stable ID version",
            "Transcript stable ID",
            "Transcript name",
            "Gene stable ID version",
            "Gene stable ID",
            "Gene Synonym",
        ],
        "Gene name";
        de = '|',
    )

end

function map_hgnc(fe_x_io_x_an = read_hgnc())

    BioLab.DataFrame.map_to(
        fe_x_io_x_an,
        BioLab.Dict.set_with_last!,
        ["prev_symbol", "alias_symbol"],
        "symbol";
        de = '|',
    )

end

function map_uniprot(pr_x_io_x_an = read_uniprot())

    pr_io_an = Dict{String, Dict{String, Any}}()

    io_ = names(pr_x_io_x_an)

    for an_ in eachrow(pr_x_io_x_an)

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

function rename(st_, st_na__...)

    st_na = Dict{String, String}()

    for st1_na1 in st_na__

        st_na = BioLab.Dict.merge(st_na, st1_na1)

    end

    n = length(st_)

    na_ = Vector{String}(undef, n)

    ma_ = Vector{Int}(undef, n)

    for (id, st) in enumerate(st_)

        if haskey(st_na, st)

            na = st_na[st]

            if st == na

                ma = 1

            else

                ma = 2

            end

        else

            na = st

            ma = 3

        end

        na_[id] = na

        ma_[id] = ma

    end

    na_, ma_

end

end
