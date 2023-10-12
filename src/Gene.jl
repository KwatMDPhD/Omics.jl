module Gene

using ..BioLab

function read_ensemble()

    BioLab.DataFrame.read(joinpath(BioLab._DA, "Gene", "ensembl.tsv.gz"))

end

function read_uniprot()

    BioLab.DataFrame.read(joinpath(BioLab._DA, "Gene", "uniprot.tsv.gz"))

end

function map_ensembl(index_x_information_x_string = read_ensemble())

    en_ge = Dict{String, String}()

    ma = Matrix(
        index_x_information_x_string[
            !,
            [
                "Transcript stable ID version",
                "Transcript stable ID",
                "Transcript name",
                "Gene stable ID version",
                "Gene stable ID",
                "Gene name",
            ],
        ],
    )

    n = size(ma, 2)

    for st_ in eachrow(ma)

        ge = st_[n]

        if ismissing(ge)

            continue

        end

        for en in st_[1:(n - 1)]

            for ens in eachsplit(en, '|')

                en_ge[ens] = ge

            end

        end

    end

    en_ge

end

function map_uniprot(index_x_information_x_string = read_uniprot())

    pr_io_an = Dict{String, Dict{String, Any}}()

    io_ = names(index_x_information_x_string)

    id = 2

    popat!(io_, id)

    pr_ = index_x_information_x_string[!, id]

    for (pr, an_) in zip(pr_, eachrow(Matrix(index_x_information_x_string[!, io_])))

        io_an = Dict{String, Any}()

        for (io, an) in zip(io_, an_)

            if ismissing(an)

                continue

            end

            if io == "Gene Names"

                an = split(an)

            elseif io == "Interacts with"

                an = split(an, "; ")

            end

            io_an[io] = an

        end

        pr = pr[1:(end - 6)]

        pr_io_an[pr] = io_an

    end

    pr_io_an

end

function rename!(fe_, fe_fe2)

    n = 0

    for (id, fe) in enumerate(fe_)

        if haskey(fe_fe2, fe)

            fe_[id] = fe_fe2[fe]

            n += 1

        elseif startswith(fe, "ENS") && contains(fe, '.')

            fe = BioLab.String.split_get(fe, '.', 1)

            if haskey(fe_fe2, fe)

                fe_[id] = fe_fe2[fe]

                n += 1

            end

        end

    end

    @info "Renamed $n / $(length(fe_))."

end

end
