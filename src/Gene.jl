module Gene

using ..Omics

function _read_hgnc()

    Omics.DataFrame.read(joinpath(Omics._DA, "Gene", "hgnc.tsv.gz"))

end

function _read_ensemble()

    Omics.DataFrame.read(joinpath(Omics._DA, "Gene", "ensembl.tsv.gz"))

end

function _read_uniprot()

    Omics.DataFrame.read(joinpath(Omics._DA, "Gene", "uniprot.tsv.gz"))

end

function map(kc_, vc = "symbol"; da = _read_hgnc())

    ke_va = Dict{String, String}()

    for ro in eachrow(da)

        va = ro[vc]

        if ismissing(va)

            continue

        end

        for kc in kc_

            ke = ro[kc]

            if ismissing(ke)

                continue

            end

            ke_va[string(ke)] = va

        end

    end

    sort(ke_va; byvalue = true)

end

function map_ensembl(da = _read_ensemble())

    ke_va = Dict{String, String}()

    ma = Matrix(
        da[
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

            for sp in eachsplit(en, '|')

                ke_va[sp] = ge

            end

        end

    end

    sort(ke_va; byvalue = true)

end

function map_uniprot(da = _read_uniprot())

    ke_va = Dict{String, Dict{String, Any}}()

    ir_ = names(da)

    id = 2

    popat!(ir_, id)

    for (pr, an_) in zip(da[!, id], eachrow(Matrix(da[!, ir_])))

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

        ke_va[pr[1:(end - 6)]] = ir_an

    end

    ke_va

end

end
