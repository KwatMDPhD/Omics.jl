module Gene

using ..Omics

function ma(ta, ck_, cv)

    ke_va = Dict{String, String}()

    ke = ta[!, ck_]

    va_ = ta[!, cv]

    for iv in eachindex(va_)

        va = va_[iv]

        if ismissing(va)

            continue

        end

        for ik in eachindex(ck_)

            ky = ke[iv, ik]

            if ismissing(ky)

                continue

            end

            for sp in eachsplit(ky, '|')

                ke_va[sp] = va

            end

        end

    end

    ke_va

end

const _DA = pkgdir(Omics, "data", "Gene")

const HT = joinpath(_DA, "hgnc.tsv.gz")

const ET = joinpath(_DA, "ensembl.tsv.gz")

const UT = joinpath(_DA, "uniprot.tsv.gz")

const EK_ = [
    "Transcript stable ID version",
    "Transcript stable ID",
    "Transcript name",
    "Gene stable ID version",
    "Gene stable ID",
]

const HV = "symbol"

const EV = "Gene name"

function map_uniprot(ta)

    pr_ir = Dict{String, Dict{String, Any}}()

    pr_ = ta[!, 2]

    ir_ = names(ta)[vcat(1, 3:end)]

    va = Matrix(ta[!, ir_])

    for ip in eachindex(pr_)

        ir_va = Dict{String, Any}()

        for ii in eachindex(ir_)

            vl = va[ip, ii]

            if ismissing(vl)

                continue

            end

            ir = ir_[ii]

            ir_va[ir] = if ir == "Gene Names"

                split(vl)

            elseif ir == "Interacts with"

                split(vl, "; ")

            else

                vl

            end

        end

        pr_ir[pr_[ip][1:(end - 6)]] = ir_va

    end

    pr_ir

end

end
