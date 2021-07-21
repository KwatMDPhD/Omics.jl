using CSV: read
using DataFrames: DataFrame
using StatsBase: sample

using ..file: read_gmt
using ..vector: list_card

function make_benchmark(id::String)::Tuple{Vector{String},Vector{Float64},Vector{String}}

    sp_ = split(id)

    if sp_[1] == "card"

        el_ = list_card()

        n_el = length(el_) / 2

        sc_ = convert.(Float64, ceil(-n_el):floor(n_el))

        el1_ = string.(collect(sp_[2]))

    elseif sp_[1] == "random"

        el_ = ["Element $ie" for ie = 1:parse(Int64, sp_[2])]

        ve = randn(convert(Int64, length(el_) / 2))

        sc_ = sort([.-ve; ve])

        el1_ = sample(el_, parse(Int64, sp_[3]))

    elseif sp_[1] == "myc"

        di = "../nb/data/"

        da = read(joinpath(di, "gene_score.tsv"), DataFrame)

        el_ = da[!, Symbol("Gene")]

        sc_ = da[!, Symbol("Score")]

        el1_ = read_gmt(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

    end

    return el_, sc_, el1_

end

export make_benchmark
