using CSV: read
using DataFrames: DataFrame
using StatsBase: sample

using ..Support: list_card  

function make_benchmark(id::String)::Tuple{Vector{String},Vector{Float64},Vector{String}}

    split_ = split(id)

    if split_[1] == "card"

        element_ = list_card()

        n = length(element_) / 2

        score_ = convert.(Float64, ceil(-n):floor(n))

        set_element_ = string.(collect(split_[2]))

    elseif split_[1] == "random"

        element_ = ["e$i" for i = 1:parse(Int64, split_[2])]

        v = randn(convert(Int64, length(element_) / 2))

        score_ = sort([.-v; v])

        set_element_ = sample(element_, parse(Int64, split_[3]))

    elseif split_[1] == "myc"

        data_directory_path = "../../nb/FeatureSetEnrichment/data/"

        df = read(joinpath(data_directory_path, "gene_score.tsv"), DataFrame)

        element_ = df[!, Symbol("Gene")]

        score_ = df[!, Symbol("Score")]

        set_element_ =
            read_gmt(joinpath(data_directory_path, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

    end

    return element_, score_, set_element_

end

export make_benchmark
