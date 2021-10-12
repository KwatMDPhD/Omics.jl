using CSV: read
using DataFrames: DataFrame
using StatsBase: sample

using ..file: read_gmt, read_table
using ..vector: list_card

function make_benchmark(id::String)::Tuple{VS, VF, VS}

    sp_ = split(id)

    if sp_[1] == "card"

        fe_ = list_card()

        n_fe = length(fe_) / 2

        sc_ = Float64.(ceil(-n_fe):floor(n_fe))

        fe1_ = string.(collect(sp_[2]))

    elseif sp_[1] == "random"

        fe_ = ["Feature $ie" for ie in 1:parse(Int64, sp_[2])]

        ve = randn(Int64(length(fe_) / 2))

        sc_ = sort([.-ve; ve])

        fe1_ = sample(fe_, parse(Int64, sp_[3]); replace = false)

    elseif sp_[1] == "myc"

        di = "../nb/data/"

        da = read_table(joinpath(di, "gene_score.tsv"))

        fe_ = da[!, Symbol("Gene")]

        sc_ = da[!, Symbol("Score")]

        fe1_ =
            read_gmt(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

    end

    return fe_, sc_, fe1_

end

export make_benchmark
