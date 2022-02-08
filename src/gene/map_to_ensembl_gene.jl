function map_to_ensembl_gene()

    return map_to_column(
        read_ensembl(),
        [
            "Transcript stable ID version",
            "Transcript stable ID",
            "Transcript name",
            "Gene stable ID version",
            "Gene stable ID",
            "Gene Synonym",
            "Gene name",
        ],
    )

end
