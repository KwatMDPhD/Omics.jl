module Gene

using ..BioLab

function _path(fi)

    return joinpath(@__DIR__, "Gene.data", fi)

end

function read_mouse()

    return BioLab.Table.read(_path("ensembl.mouse_human.tsv.gz"))

end

# TODO: Test multiple dispatch.
function map_mouse(fe_x_io_an = read_mouse(); pr = false)

    ke_va = Dict{String, String}()

    for (ke, va) in zip(fe_x_io_an[!, "Gene name"], fe_x_io_an[!, "Human gene name"])

        if ismissing(ke) || ismissing(va)

            continue

        end

        BioLab.Dict.set_with_last!(ke_va, ke, va; pr)

    end

    return ke_va

end

function read_ensembl()

    return BioLab.Table.read(_path("ensembl.tsv.gz"))

end

# TODO: Test multiple dispatch.
function map_ensembl(fe_x_io_an = read_ensembl(); pr = false)

    return BioLab.DataFrame.map_to(
        fe_x_io_an,
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

function read_hgnc()

    return BioLab.Table.read(_path("hgnc_complete_set.tsv.gz"))

end

# TODO: Test multiple dispatch.
function map_hgnc(fe_x_io_an = read_hgnc(); pr = false)

    return BioLab.DataFrame.map_to(
        fe_x_io_an,
        BioLab.Dict.set_with_last!,
        ["prev_symbol", "alias_symbol"],
        "symbol";
        de = '|',
        pr,
    )

end

function rename(st_, st_na__...; prm = false, pr = true)

    st_na = Dict{String, String}()

    for st1_na1 in st_na__

        st_na = BioLab.Dict.merge(st_na, st1_na1; pr = prm)

    end

    n = length(st_)

    na_ = Vector{String}(undef, n)

    ma_ = Vector{Int}(undef, n)

    n_1 = 0

    n_2 = 0

    n_3 = 0

    for (id, st) in enumerate(st_)

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

    BioLab.check_print(
        pr,
        "👍 $n_1 (kept).",
        "\n",
        "✌️ $n_2 (renamed).",
        "\n",
        "👎 $n_3 (failed to rename).",
    )

    return na_, ma_

end

function read_uniprot()

    return BioLab.Table.read(_path("uniprot.tsv.gz"))

end

# TODO: Test multiple dispatch.
function map_uniprot(pr_x_io_x_an = read_uniprot(); pr = false)

    pr_io_an = Dict{String, Dict{String, Any}}()

    io_ = names(pr_x_io_x_an)

    for an_ in eachrow(pr_x_io_x_an)

        io_an = Dict{String, Any}()

        # TODO: Use indexing to speed up.
        for (io, an) in zip(io_, an_)

            if io == "Entry Name"

                BioLab.Dict.set_with_last!(
                    pr_io_an,
                    BioLab.String.split_get(an, "_HUMAN", 1),
                    io_an;
                    pr,
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
