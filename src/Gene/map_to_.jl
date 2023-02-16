function _map_to(wh)

    return BioLab.DataFrame.map_to(read(wh), fr_, to; de = '|', pr = false)

end

function map_to_ensembl()

    return _map_to(
        [
            "Transcript stable ID version",
            "Transcript stable ID",
            "Transcript name",
            "Gene stable ID version",
            "Gene stable ID",
            "Gene Synonym",
        ],
        "Gene name",
    )

end

function map_to_hgnc()

    return _map_to(["prev_symbol", "alias_symbol"], "symbol")

end
