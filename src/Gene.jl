module Gene

using ..Nucleus

function read_ensemble()

    Nucleus.DataFrame.read(joinpath(Nucleus._DA, "Gene", "ensembl.tsv.gz"))

end

function read_uniprot()

    Nucleus.DataFrame.read(joinpath(Nucleus._DA, "Gene", "uniprot.tsv.gz"))

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

    for st_ in eachrow(ma)

        ge = st_[end]

        if ismissing(ge)

            continue

        end

        for en in st_[1:(end - 1)]

            for ens in eachsplit(en, '|')

                en_ge[ens] = ge

            end

        end

    end

    en_ge

end

function map_uniprot(index_x_information_x_string = read_uniprot())

    pr_ir_an = Dict{String, Dict{String, Any}}()

    ir_ = names(index_x_information_x_string)

    id = 2

    popat!(ir_, id)

    for (pr, an_) in zip(
        index_x_information_x_string[!, id],
        eachrow(Matrix(index_x_information_x_string[!, ir_])),
    )

        ir_an = Dict{String, Any}()

        for (ir, an) in zip(ir_, an_)

            if ismissing(an)

                continue

            end

            if ir == "Gene Names"

                an = split(an)

            elseif ir == "Interacts with"

                an = split(an, "; ")

            end

            ir_an[ir] = an

        end

        pr_ir_an[pr[1:(end - 6)]] = ir_an

    end

    pr_ir_an

end

function rename(fe_, fe_na)

    na_ = copy(fe_)

    nr = 0

    for (i1, fe) in enumerate(na_)

        if haskey(fe_na, fe)

            na_[i1] = fe_na[fe]

            nr += 1

        elseif startswith(fe, "ENS") && contains(fe, '.')

            fe = split(fe, '.'; limit = 2)[1]

            if haskey(fe_na, fe)

                na_[i1] = fe_na[fe]

                nr += 1

            end

        end

    end

    @info "Renamed $nr / $(lastindex(na_))."

    na_

end

end
