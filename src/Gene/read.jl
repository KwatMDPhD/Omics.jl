function read(wh)

    BioLab.Table.read(
        _path(Dict("ensembl" => "ensembl.tsv.gz", "hgnc" => "hgnc_complete_set.tsv.gz")[wh]),
    )

end
