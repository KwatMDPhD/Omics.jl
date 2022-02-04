function make_string_to_ensembl_gene()::Dict{String,String}

    return map_to_column(
        read_ensembl(),
        [
            "Gene name",
            "Transcript stable ID version",
            "Transcript stable ID",
            "Transcript name",
            "Gene stable ID version",
            "Gene stable ID",
            "Gene Synonym",
        ],
    )

end
