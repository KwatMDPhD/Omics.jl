function read(wh)

    BioinformaticsCore.Table.read(
        _path(Dict("ensembl" => "ensembl.tsv.gz", "hgnc" => "hgnc_complete_set.tsv.gz")[wh]),
    )

end
