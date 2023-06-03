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

function map_mouse(fe_x_io_x_an = read_mouse(); pr = false)

    BioLab.DataFrame.map_to(
        fe_x_io_x_an,
        BioLab.Dict.set_with_last!,
        ["Gene name"],
        "Human gene name";
        pr,
    )

end

function map_ensembl(fe_x_io_x_an = read_ensembl(); pr = false)

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
        pr,
    )

end

function map_hgnc(fe_x_io_x_an = read_hgnc(); pr = false)

    BioLab.DataFrame.map_to(
        fe_x_io_x_an,
        BioLab.Dict.set_with_last!,
        ["prev_symbol", "alias_symbol"],
        "symbol";
        de = '|',
        pr,
    )

end

function map_uniprot(pr_x_io_x_an = read_uniprot(); pr = false)

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

                    error("$an does not end with _HUMAN.")

                end

                BioLab.Dict.set_with_last!(pr_io_an, an[1:(end - 6)], io_an; pr)

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

function rename(st_, st_na__...; prm = false, pr = true)

    st_na = Dict{String, String}()

    for st1_na1 in st_na__

        st_na = BioLab.Dict.merge(st_na, st1_na1; pr = prm)

    end

    n = length(st_)

    na_ = Vector{String}(undef, n)

    ma_ = Vector{Int}(undef, n)

    n1 = 0

    n2 = 0

    n3 = 0

    for (id, st) in enumerate(st_)

        if haskey(st_na, st)

            na = st_na[st]

            if st == na

                ma = 1

                n1 += 1

            else

                ma = 2

                n2 += 1

            end

        else

            na = st

            ma = 3

            n3 += 1

        end

        na_[id] = na

        ma_[id] = ma

    end

    BioLab.check_print(pr, "Kept $n1.", '\n', "Renamed $n2.", '\n', "Failed to rename $n3.")

    na_, ma_

end

end
