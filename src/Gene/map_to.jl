function map_to(wh)

    OnePiece.DataFrame.map_to(
        read(wh),
        Dict(
            "ensembl" => [
                "Transcript stable ID version",
                "Transcript stable ID",
                "Transcript name",
                "Gene stable ID version",
                "Gene stable ID",
                "Gene Synonym",
                "Gene name",
            ],
            "hgnc" => ["prev_symbol", "alias_symbol", "symbol"],
        )[wh],
        pr = false,
    )

end
