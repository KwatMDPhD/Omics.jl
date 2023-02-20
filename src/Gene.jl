module Gene

using ..BioLab

function _path(fi)

    return joinpath(@__DIR__, "data", fi)

end

function read_mouse()

    return BioLab.Table.read(_path("ensembl.mouse_human.tsv.gz"))

end

function map_mouse()

    fe_x_in_x_an = read_mouse()

    ke_va = Dict{String, String}()

    for (ke, va) in zip(fe_x_in_x_an[!, "Gene name"], fe_x_in_x_an[!, "Human gene name"])

        if ismissing(ke) || ismissing(va)

            continue

        end

        BioLab.Dict.set_with_last!(ke_va, ke, va)

    end

    return ke_va

end

function read_ensembl()

    return BioLab.Table.read(_path("ensembl.tsv.gz"))

end

function map_ensembl()

    return BioLab.DataFrame.map_to(
        read_ensembl(),
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
        pr = false,
    )

end

function read_hgnc()

    return BioLab.Table.read(_path("hgnc_complete_set.tsv.gz"))

end

function map_hgnc()

    return BioLab.DataFrame.map_to(
        read_hgnc(),
        ["prev_symbol", "alias_symbol"],
        "symbol";
        de = '|',
        pr = false,
    )

end

function rename(st_; mo = true, en = true, hg = true)

    st_na = Dict{String, String}()

    if mo

        merge!(st_na, map_mouse())

    end

    if en

        merge!(st_na, map_ensemble())

    end

    if hg

        merge!(st_na, map_hgnc())

    end

    n = length(st_)

    na_ = Vector{String}(undef, n)

    ma_ = Vector{Int}(undef, n)

    n_1 = 0

    n_2 = 0

    n_3 = 0

    for id in 1:n

        if haskey(st_na, st)

            na = st_na[st]

            if st == na

                ma = 1

                n_1 += 1

            else

                ma = 2

                n_2 += 1

            end

        else

            na = st

            ma = 3

            n_3 += 1

        end

        na_[id] = na

        ma_[id] = ma

    end

    for (n, em) in ((n_1, "👍"), (n_2, "✅"), (n_3, "❌"))

        println("$em $n")

    end

    return na_, ma_

end

function read_uniprot()

    return BioLab.Table.read(_path("uniprot.tsv.gz"))

end

function map_uniprot()

    pr_x_in_x_an = read_uniprot()

    pr_io_an = Dict{String, Dict{String, Vector{String}}}()

    in_ = names(pr_x_in_x_an)

    for an_ in eachrow(pr_x_in_x_an)

        io_an = Dict{String, Vector{String}}()

        # TODO: Use indexing to speed up.
        for (io, an) in zip(in_, an_)

            if io == "Entry Name"

                BioLab.Dict.set_with_last!(
                    pr_io_an,
                    BioLab.String.split_and_get(an, "_HUMAN", 1),
                    io_an,
                )

            else

                if an isa AbstractString

                    if io == "Gene Names"

                        an = split(an, ' ')

                    elseif io == "Interacts with"

                        an = split(an, "; ")

                    end

                end

                io_an[io] = an

            end

        end

    end

    return pr_io_an

end

end
